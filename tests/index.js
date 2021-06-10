const test = require('ava')
const fs = require('fs-extra')
const globby = require('globby')

const year = new Date().getFullYear()
const yearRegex = new RegExp(`Copyright \\(c\\) ${year} GitHub Inc\\.`)
const octiconsLib = fs.readdirSync('./lib/build/svg')
const octiconsSymbols = fs.readdirSync('./lib/build/symbols')
const octiconsData = require('../lib/build/data.json')

test(`LICENSE files have the current year ${year}`, t => {
  return globby(['**/LICENSE', '!**/node_modules/**/LICENSE', '!**/vendor/**/LICENSE']).then(paths => {
    t.plan(paths.length)
    return paths.map(path => {
      const license = fs.readFileSync(path, 'utf8')
      return t.regex(license, yearRegex, `The license "${path}" does not include the current year ${year}`)
    })
  })
})

test('SVG icons exist', t => {
  t.not(octiconsLib.length, 0, `We didn't find any svg files`)
})

test('SVG symbols exist', t => {
  t.not(octiconsSymbols.length, 0, `We didn't find any symbols files`)
})

test('Data file exist', t => {
  t.not(octiconsData.length, 0, `We didn't find any data files`)
})

const names = {}
for (const octicon of Object.values(octiconsData)) {
  test(`No duplicate ${octicon.name} icon`, t => {
    if (names[octicon.name]) {
      t.fail(
        `Found duplicate '${octicon.name}' icons in the figma file. Please rename one of them. https://www.figma.com/file/${octicon.file}?node-id=${octicon.id}`
      )
    } else {
      names[octicon.name] = octicon
      t.pass()
    }
  })
}
