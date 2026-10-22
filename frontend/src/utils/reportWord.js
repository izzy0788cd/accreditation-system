import { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, WidthType, HeadingLevel, BorderStyle, Footer, PageNumber } from "docx";

// Export the generated report only, never the surrounding controls or live data.
// This keeps saved versions, selected sections and hidden names identical to preview.
const text = node => node.textContent?.trim() || "";
const paragraph = (value, options = {}) => new Paragraph({
  children: String(value).split(/\r?\n/).map((line, i) => new TextRun({ text: line, break: i ? 1 : undefined })),
  spacing: { after: 120 }, ...options,
});
const border = { style: BorderStyle.SINGLE, size: 4, color: "D9D9D9" };

function table(headers, rows, widths) {
  const makeRow = (values, index) => new TableRow({
    tableHeader: index === 0,
    children: values.map((value, i) => new TableCell({
      width: { size: widths[i], type: WidthType.DXA },
      margins: { top: 100, bottom: 100, left: 100, right: 100 },
      shading: { fill: index === 0 ? "DFEAF0" : index % 2 ? "FFFFFF" : "F5F7F8" },
      children: [paragraph(value, { spacing: { after: 0 }, children: String(value).split(/\r?\n/).map((line, j) => new TextRun({ text: line, bold: index === 0, break: j ? 1 : undefined })) })],
    })),
  });
  return new Table({
    width: { size: 9360, type: WidthType.DXA }, columnWidths: widths,
    borders: { top: border, bottom: border, left: border, right: border, insideHorizontal: border, insideVertical: border },
    rows: [headers, ...rows].map(makeRow),
  });
}

function cellText(node) {
  const clone = node.cloneNode(true);
  clone.querySelectorAll('[role="checkbox"]').forEach(box => { box.textContent = box.getAttribute("aria-checked") === "true" ? "Yes" : "No"; });
  return text(clone);
}

export function reportWordDocument(root) {
  if (!root) throw new Error("Generate a report preview first.");
  function blocks(node) {
    if (node.nodeType === 3) return text(node) ? [paragraph(text(node))] : [];
    if (node.nodeType !== 1) return [];
    const tag = node.tagName.toLowerCase();
    if (["style", "script", "nav", "svg"].includes(tag)) return [];
    if (node.classList.contains("report-chart-summary")) {
      const rows = [...node.querySelectorAll(".report-chart-legend > div")].map(row => [...row.children].slice(1).map(text));
      return [table(["Assessment distribution", "Count", "Percentage"], rows, [6000, 1680, 1680]), ...[...node.querySelectorAll(".report-chart-legend > p")].map(p => paragraph(text(p)))];
    }
    if (node.classList.contains("report-metrics") || node.classList.contains("report-executive-metrics")) {
      return [...node.children].map(child => paragraph([...child.children].map(text).join(" — ")));
    }
    if (tag === "table") {
      const rows = [...node.querySelectorAll("tr")].map(row => [...row.children].map(cellText));
      if (!rows.length) return [];
      const count = rows[0].length;
      const evidence = node.closest(".report-evidence");
      const widths = evidence ? (count === 4 ? [700, 6660, 1000, 1000] : [700, 7660, 1000])
        : count === 6 ? [3460, 1000, 1100, 700, 1000, 2100] : [4260, 1200, 1400, 1000, 1500];
      return [table(rows[0], rows.slice(1), widths)];
    }
    if (tag === "dl") return [...node.children].map(child => paragraph([...child.children].map(text).join(": ")));
    if (/^h[1-4]$/.test(tag)) return [paragraph(text(node), { heading: ({ h1: HeadingLevel.TITLE, h2: HeadingLevel.HEADING_1, h3: HeadingLevel.HEADING_2, h4: HeadingLevel.HEADING_3 })[tag], keepNext: true })];
    if (tag === "p" || tag === "figcaption" || tag === "li" || node.classList.contains("report-text")) return [paragraph(text(node), tag === "li" ? { bullet: { level: 0 } } : {})];
    if (node.classList.contains("report-result-scores")) return [paragraph([...node.children].map(text).join(" | "))];
    if (node.classList.contains("report-masthead") || tag === "footer") return [paragraph([...node.children].map(text).join(" · "))];
    if (node.classList.contains("report-section-heading")) return [paragraph(`Standard ${text(node.querySelector(".report-section-number"))} ${text(node.querySelector("h2"))}`, { heading: HeadingLevel.HEADING_1, keepNext: true })];
    return [...node.childNodes].flatMap(blocks);
  }
  return new Document({
    creator: "NHSS Accreditation System", title: "Survey assessment report",
    styles: { default: { document: { run: { font: "Calibri", size: 22, color: "000000" }, paragraph: { spacing: { after: 120 } } },
      title: { run: { size: 36, bold: true, color: "000000" } },
      heading1: { run: { size: 28, bold: true, color: "000000" } },
      heading2: { run: { size: 24, bold: true, color: "000000" } },
      heading3: { run: { size: 22, bold: true, color: "000000" } },
    } },
    sections: [{
      properties: { page: { size: { width: 11906, height: 16838 }, margin: { top: 1134, bottom: 1134, left: 1273, right: 1273 } } },
      footers: { default: new Footer({ children: [new Paragraph({ children: [new TextRun("Page "), new TextRun({ children: [PageNumber.CURRENT] })] })] }) },
      children: [...blocks(root), paragraph("Editable Word export. Changes made in Word do not update the system or its saved approval record.")],
    }],
  });
}

export async function downloadReportWord(root, report) {
  const blob = await Packer.toBlob(reportWordDocument(root));
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  const facility = String(report.survey.facilityName || "facility").replace(/[^a-z0-9 -]/gi, "").slice(0, 80);
  anchor.href = url;
  anchor.download = `${facility}-survey-${report.survey.surveyId}${report.savedVersion ? `-v${report.savedVersion.versionNumber}` : "-draft"}.docx`;
  document.body.appendChild(anchor);
  anchor.click();
  anchor.remove();
  setTimeout(() => URL.revokeObjectURL(url), 30000);
}
