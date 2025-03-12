# WikiSource Exporter

[![GitHub release](https://img.shields.io/github/v/release/ruslanbay/wikisource-exporter)](https://github.com/ruslanbay/wikisource-exporter/releases)
[![License](https://img.shields.io/github/license/ruslanbay/wikisource-exporter)](LICENSE)

A GitHub Action that exports WikiSource documents to various formats (txt, epub, pdf) using the [ws-export](https://github.com/wikimedia/ws-export) tool.

## Features

- Export WikiSource documents to multiple formats (txt, epub, pdf)
- Support for multiple languages
- Optional credits list inclusion
- Caching support for faster exports
- Artifact upload support

## Usage

### Basic Example

```yaml
- uses: ruslanbay/wikisource-exporter@v3.1.0
  with:
    title: Constitution_of_the_United_States_of_America
    lang: en
    format: txt
```

### Complete Example

```yaml
name: Export WikiSource Document

on:
  workflow_dispatch:
    inputs:
      title:
        description: 'Page title'
        required: true
        default: 'Constitution_of_the_United_States_of_America'
      lang:
        description: 'Language code'
        required: true
        default: 'en'
        type: choice
        options: ['ru', 'en', 'de', 'fr']
      format:
        description: 'Output format'
        required: true
        default: 'txt'
        type: choice
        options: ['txt', 'epub', 'pdf']

jobs:
  export:
    runs-on: ubuntu-latest
    steps:
      - name: Export document
        uses: ruslanbay/wikisource-exporter@v3.1.0
        with:
          title: ${{ github.event.inputs.title }}
          lang: ${{ github.event.inputs.lang }}
          format: ${{ github.event.inputs.format }}
          nocredits: true
          nocache: false

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: wikisource-document
          path: output
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `title` | Page title (e.g. Constitution_of_the_United_States_of_America) | Yes | - |
| `lang` | Language code (e.g. en, ru, de, fr) | Yes | en |
| `format` | Output format (txt, epub, pdf) | Yes | txt |
| `nocredits` | Do not include the credits list | No | true |
| `nocache` | Do not cache anything (re-fetch all data) | No | false |

## Outputs

| Output | Description |
|--------|-------------|
| `output-path` | Path to the exported document |

## Examples

### Export a Russian document as PDF

```yaml
- uses: ruslanbay/wikisource-exporter@v3.1.0
  with:
    title: Конституция_Российской_Федерации
    lang: ru
    format: pdf
```

### Export with credits and caching enabled

```yaml
- uses: ruslanbay/wikisource-exporter@v3.1.0
  with:
    title: Don_Quixote
    lang: en
    format: epub
    nocredits: false
    nocache: false
```

## Development

The action is built using:
- Ubuntu 24.04 as the base image
- PHP and required extensions
- Calibre for PDF conversion
- GitHub Actions toolkit

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## Credits

- [ws-export](https://github.com/wikimedia/ws-export) - The core tool used for exporting WikiSource documents
- [Wikisource](https://wikisource.org/) - The free library that is providing the content
- Created by [ruslanbay](https://github.com/ruslanbay)

## Version History

- **v3.1.0** (2025-03-12)
  - Initial release
  - Support for txt, epub, and pdf formats
  - Multiple language support
  - Optional credits and caching
