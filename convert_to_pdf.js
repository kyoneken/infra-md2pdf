const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

async function convertToPdf(files) {
  const browser = await chromium.launch();

  for (const file of files) {
    if (path.extname(file) === '.html') {
      const page = await browser.newPage();
      await page.goto(`file:${path.join(process.cwd(), file)}`, {waitUntil: 'networkidle'});
      await page.pdf({path: `${path.basename(file, '.html')}.pdf`, format: 'A4'});
      await page.close();
    }
  }

  await browser.close();
}

const filesToConvert = process.argv.slice(2);
convertToPdf(filesToConvert).catch(console.error);