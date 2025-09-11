# GitHub Actions Build Workflow for Lazarus Projects

This repository contains a GitHub Actions workflow that automatically builds all Lazarus projects (.lpr files) found in the repository. The workflow automatically fetches the latest Windows 32-bit Lazarus installer from SourceForge and bypasses the timer/redirect page for faster downloads.

## Workflow Overview

The workflow (`/.github/workflows/build-lazarus.yml`) performs the following steps:

1. **Project Discovery**: Automatically scans the repository to find all `.lpr` (Lazarus project) files
2. **Lazarus Download**: Fetches the latest Windows 32-bit Lazarus installer URL from SourceForge
3. **Installation**: Downloads and silently installs Lazarus with Free Pascal Compiler
4. **Building**: Builds each discovered project using `lazbuild`
5. **Artifacts**: Archives build outputs and executables

## Automatic SourceForge URL Fetching

The script `/.github/scripts/get-lazarus-url.sh` implements multiple methods to fetch the latest Lazarus installer:

### Method 1: SourceForge Directory Parsing
- Parses the SourceForge directory listing to find the latest version
- Extracts version numbers and tests the most recent releases
- Supports different FPC (Free Pascal Compiler) version combinations

### Method 2: Known Version Fallback
- Tests a curated list of known recent Lazarus versions
- Includes common version/FPC combinations like:
  - Lazarus 2.2.6 with FPC 3.2.2
  - Lazarus 2.2.4 with FPC 3.2.2
  - Lazarus 3.0+ with FPC 3.2.2

### Method 3: Alternative URL Patterns
- Tests alternative naming conventions for Lazarus installers
- Handles edge cases where the standard pattern doesn't apply

### Direct Download URLs
The script converts SourceForge file page URLs to direct download URLs using the pattern:
```
https://downloads.sourceforge.net/project/lazarus/Lazarus%20Windows%2032%20bits/...
```

This bypasses the SourceForge timer/redirect page that normally appears when downloading files.

## Workflow Triggers

The workflow runs automatically on:
- Push to `main` branch
- Pull requests targeting `main` branch

## Projects Built

The workflow will automatically discover and build:
- **DaiPak** (`DaiPakV2/daipak.lpr`) - Daikatana Pack Reader
- **DaiWal** (`DaiWalV2/daiwal.lpr`) - Daikatana WAL file reader/converter  
- **DaiMdl** (`DaiMdlV2/modelview.lpr`) - Daikatana Model Viewer

## Build Requirements

- **Windows runner**: Uses `windows-latest` for compatibility with Lazarus Windows installer
- **Lazarus IDE**: Automatically downloaded and installed from SourceForge
- **Free Pascal Compiler**: Included with Lazarus installation
- **LCL (Lazarus Component Library)**: Required dependency for the GUI projects

## Build Artifacts

The workflow creates an archive containing:
- Compiled executables (`.exe` files)
- Dynamic libraries (`.dll` files)  
- Resource files
- Library directories
- Build logs and outputs

Artifacts are retained for 7 days and can be downloaded from the GitHub Actions run page.

## Fallback Mechanism

If the automatic URL fetching fails:
1. The script tries multiple methods to find a working Lazarus version
2. If all methods fail, the workflow uses a predefined fallback version (currently 2.2.6)
3. Build continues with the fallback version to ensure consistency

## Error Handling

The workflow includes comprehensive error handling:
- URL validation before downloading
- Installation verification (checks for `lazbuild.exe`)
- Per-project build status tracking
- Detailed build summary with success/failure counts
- Workflow fails if any project build fails

## Customization

### Adding New Projects
Simply add `.lpr` files to the repository - they will be automatically discovered and built.

### Updating Fallback Version
Edit the `FALLBACK_LAZARUS_VERSION` environment variable in the workflow file.

### Modifying Known Versions
Update the `KNOWN_VERSIONS` list in `get-lazarus-url.sh` to include newer Lazarus releases.

## Security Considerations

- All downloads are verified with HTTP status checks
- URLs are validated before use
- The installer runs with silent installation flags only
- No external scripts or unauthorized downloads are executed

## Troubleshooting

### Common Issues

1. **SourceForge Access Problems**: The script includes multiple fallback methods
2. **Installation Failures**: The workflow verifies Lazarus installation before building
3. **Build Failures**: Individual project failures are reported with details
4. **Missing Dependencies**: Projects requiring additional packages may need workflow updates

### Logs and Debugging

- Each step in the workflow provides detailed logging
- Build output for each project is captured separately
- SourceForge URL fetching includes verbose output for debugging

## Maintenance

The workflow should be updated periodically to:
1. Add newer Lazarus versions to the known versions list
2. Update the fallback version to a more recent stable release
3. Adjust SourceForge URL patterns if they change
4. Add any new project-specific build requirements