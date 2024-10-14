const { chromium } = require('playwright');
const fs = require('fs').promises;
const path = require('path');

async function convertToPdf(files, outputDir) {
  const browser = await chromium.launch();

  try {
    for (const file of files) {
      if (path.extname(file).toLowerCase() === '.html') {
        const page = await browser.newPage();
        const absoluteFilePath = path.resolve(file);
        console.log(`Processing: ${absoluteFilePath}`);

        try {
          await page.goto(`file:${absoluteFilePath}`, { waitUntil: 'networkidle' });
          const pdfFileName = `${path.basename(file, '.html')}.pdf`;
          const pdfPath = path.join(outputDir, pdfFileName);
          await page.pdf({ path: pdfPath, format: 'A4' });
          console.log(`PDF created: ${pdfPath}`);
        } catch (error) {
          console.error(`Error processing ${file}:`, error.message);
        } finally {
          await page.close();
        }
      } else {
        console.warn(`Skipping non-HTML file: ${file}`);
      }
    }
  } finally {
    await browser.close();
  }
}

async function main() {
  const args = process.argv.slice(2);
  if (args.length < 2) {
    console.error('Usage: node convert_to_pdf.js <output_directory> <file1.html> [file2.html] ...');
    process.exit(1);
  }

  const outputDir = args[0];
  const filesToConvert = args.slice(1);

  try {
    await fs.mkdir(outputDir, { recursive: true });
    await convertToPdf(filesToConvert, outputDir);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

main();