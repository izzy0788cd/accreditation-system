function FrameworkFilters({
  search,
  onSearchChange,
  searchPlaceholder,
  parentLabel,
  parentValue,
  onParentChange,
  parentOptions = [],
  filters = [],
  applicability,
  onApplicabilityChange,
  resultCount,
  totalCount,
}) {
  const hasFilters = search || parentValue || applicability || filters.some((filter) => filter.value);
  const allLabel = (label) => ({
    Standard: "All standards",
    Criterion: "All criteria",
    Compliance: "All compliance requirements",
  }[label] || `All ${label.toLowerCase()}`);

  const clearFilters = () => {
    onSearchChange("");
    onParentChange?.("");
    onApplicabilityChange?.("");
    filters.forEach((filter) => filter.onChange(""));
  };

  return (
    <div className="mb-5 rounded-xl border border-[#dce9e7] bg-[#f8fbfa] p-3 sm:p-4">
      <div className="flex flex-col gap-3 lg:flex-row lg:flex-wrap lg:items-end">
        <label className="w-full text-xs font-semibold uppercase tracking-wider text-[#527076] lg:min-w-[22rem] lg:flex-[2_1_28rem]">
          Search
          <input
            value={search}
            onChange={(event) => onSearchChange(event.target.value)}
            placeholder={searchPlaceholder}
            className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] bg-white px-4 py-3 text-sm normal-case tracking-normal text-[#143c42] outline-none transition placeholder:text-[#8ba3a0] focus:border-[#087c77] focus:ring-2 focus:ring-[#087c77]/15"
          />
        </label>

        {filters.map((filter) => (
          <label key={filter.label} className="w-full text-xs font-semibold uppercase tracking-wider text-[#527076] sm:min-w-40 lg:w-auto lg:flex-1">
            {filter.label}
            <select
              value={filter.value}
              onChange={(event) => filter.onChange(event.target.value)}
              className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm normal-case tracking-normal text-[#143c42] outline-none transition focus:border-[#087c77] focus:ring-2 focus:ring-[#087c77]/15"
            >
              <option value="">{allLabel(filter.label)}</option>
              {filter.options.map((option) => (
                <option key={option.value} value={option.value}>{option.label}</option>
              ))}
            </select>
          </label>
        ))}

        {parentLabel && (
          <label className="w-full text-xs font-semibold uppercase tracking-wider text-[#527076] sm:min-w-44 lg:w-auto lg:flex-1">
            {parentLabel}
            <select
              value={parentValue}
              onChange={(event) => onParentChange(event.target.value)}
              className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm normal-case tracking-normal text-[#143c42] outline-none transition focus:border-[#087c77] focus:ring-2 focus:ring-[#087c77]/15"
            >
              <option value="">{allLabel(parentLabel)}</option>
              {parentOptions.map((option) => (
                <option key={option.value} value={option.value}>{option.label}</option>
              ))}
            </select>
          </label>
        )}

        {onApplicabilityChange && (
          <label className="w-full text-xs font-semibold uppercase tracking-wider text-[#527076] sm:min-w-40 lg:w-auto lg:flex-1">
            Status
            <select
              value={applicability}
              onChange={(event) => onApplicabilityChange(event.target.value)}
              className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm normal-case tracking-normal text-[#143c42] outline-none transition focus:border-[#087c77] focus:ring-2 focus:ring-[#087c77]/15"
            >
              <option value="">All records</option>
              <option value="applicable">Applicable</option>
              <option value="not-applicable">Not applicable</option>
            </select>
          </label>
        )}

        <div className="flex items-center gap-3 pb-0.5 lg:ml-auto">
          <p className="whitespace-nowrap text-sm text-[#527076]" aria-live="polite">
            <span className="font-semibold text-[#143c42]">{resultCount}</span> of {totalCount}
          </p>
          {hasFilters && (
            <button
              type="button"
              onClick={clearFilters}
              className="whitespace-nowrap rounded-lg px-3 py-2 text-sm font-semibold text-[#087c77] transition hover:bg-teal-100"
            >
              Clear filters
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

export default FrameworkFilters;
