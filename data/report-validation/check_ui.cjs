const { chromium } = require('C:/Users/ishma/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs');
(async()=>{
 const browser=await chromium.launch({headless:true,channel:"chrome"});
 const page=await browser.newPage({viewport:{width:1280,height:960}});
 const source=JSON.parse(fs.readFileSync('data/report-validation/external.json','utf8'));
 // A bounded UI fixture exercises comparison differences without changing database results.
 source.items=source.items.slice(0,8).map((i,n)=>({...i,scoreId:n%3+1,scoreValue:n%3,riskLabel:n%3===0?'High':'Low',riskSeverity:n%3===0?3:1,complianceComments:'DUMMY SURVEY — UI verification only.'}));
 source.internalItems=source.internalItems.filter(i=>source.items.some(a=>a.complianceId===i.complianceId)).map(i=>({...i,scoreId:3,scoreValue:2}));
 await page.addInitScript(()=>sessionStorage.setItem('accreditation-auth-tab','active'));
 await page.route('http://localhost:5157/api/**',async route=>{
  const url=new URL(route.request().url());
  let data;
  if(url.pathname.endsWith('/auth/refresh'))data={token:'ui-fixture',username:'Report review',roleName:'Admin'};
  else if(url.pathname.endsWith('/users/me'))data={firstName:'Report',lastName:'review',userId:1};
  else if(url.pathname.endsWith('/versions'))data=[];
  else if(url.pathname.endsWith('/reports/surveys'))data=[{...source.survey}];
  else if(url.pathname.endsWith('/reports/surveys/2'))data=source;
  else return route.fulfill({status:404,json:{}});
  await route.fulfill({json:data});
 });
 const errors=[];page.on('pageerror',error=>errors.push(error.message));
 await page.goto('http://localhost:5173/reports'); await page.waitForTimeout(1500); console.log('PAGE', (await page.locator('body').innerText()).slice(0,900), errors);
 await page.locator('.report-settings select').nth(1).selectOption('2');
 await page.getByRole('button',{name:'Generate preview'}).waitFor();
 await page.getByLabel('Evidence checklist',{exact:true}).check();
 await page.getByLabel('Report detail').selectOption('findings');
 await page.getByLabel('Add a recommendation for').selectOption(String(source.items[0].complianceId));
 await page.getByLabel('Recommended action',{exact:true}).fill('Review the simulated documentation gap and arrange a follow-up assessment.');
 await page.getByLabel('Responsible officer').fill('Quality manager');
 await page.getByLabel('Due date',{exact:true}).fill('2026-12-01');
 await page.getByLabel('Reviewer name (for signature)').fill('Review coordinator');
 await page.getByRole('button',{name:'Generate preview'}).click();
 await page.getByRole('heading',{name:'Executive summary',exact:true}).waitFor();
 await page.locator('.survey-report').screenshot({path:'data/report-validation/report-preview.png'});
 await page.pdf({path:'data/report-validation/report-print.pdf',preferCSSPageSize:true,printBackground:true});
 await page.setViewportSize({width:390,height:844});
 await page.locator('.survey-report').screenshot({path:'data/report-validation/report-mobile.png'});
 if(errors.length)throw new Error(errors.join('\n'));
 console.log('Report UI, findings filter, action editor and print render passed.');
 await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});




