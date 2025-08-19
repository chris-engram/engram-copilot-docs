# Args: `<drive-folder-id>` `[custom-instructions]`. v1.5.0. Ingest specifications from Google Drive with curl-based direct downloads and image-aware PDF export.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/ingest-specs-from-drive` in bash.

Input: $ARGUMENTS (format: drive-folder-id [custom-instructions])

## Summary

Ingests specification documents from Google Drive folders using curl-based direct downloads for optimal content preservation. The command now prioritizes curl for downloading Google Docs from folders with "anyone with the link" permissions, using the Google Docs export URLs that bypass API limitations. When documents contain images, it automatically downloads as PDF to preserve visual content. Uses Claude's Task tool to process each subfolder concurrently. For folders with restricted permissions, it falls back to Zapier MCP functions with the Google Drive API v3 export endpoint. It navigates through folder structures, exports Google Docs content as markdown or PDF, and creates corresponding files in the `designs/specs/{drive root folder name}/` directory while maintaining the original folder structure.

## Usage

```bash
/design:ingest-specs-from-drive <drive-folder-id> [custom-instructions]
```

## Arguments

- `<drive-folder-id>`: The Google Drive folder ID to start ingestion from (REQUIRED)
  - This is the root folder containing specification documents
  - Example: `1ABC2DEF3GHI4JKL5MNO6PQR7STU8VWX`
- `[custom-instructions]`: Optional instructions to modify default behavior
  - Default: Navigate through all subfolders and read all Google Docs
  - Can specify folder patterns, file filters, or processing rules

## Examples

```bash
# Ingest all specs from a folder
/design:ingest-specs-from-drive 1ABC2DEF3GHI4JKL5MNO6PQR7STU8VWX

# Ingest with custom instructions
/design:ingest-specs-from-drive 1ABC2DEF3GHI4JKL5MNO6PQR7STU8VWX "only process folders named 'v2' or 'latest'"

# Ingest with file filtering
/design:ingest-specs-from-drive 1XYZ2ABC3DEF4GHI5JKL6MNO "skip files containing 'draft' in the name"

# Ingest from a public folder (will use curl direct download)
/design:ingest-specs-from-drive 1PUB2LIC3FOL4DER5ID6 "this folder has 'anyone with link' permission"

# Ingest docs with images (will download as PDF to preserve images)
/design:ingest-specs-from-drive 1IMG2DOC3FOL4DER5ID6 "download as PDF if documents contain images"
```

## What This Command Does

### ⚡ Parallel Processing Architecture

This command leverages Claude's Task tool to process multiple subfolders concurrently:

```
Root Folder
├── 📄 Doc1.gdoc (processed by main command)
├── 📄 Doc2.gdoc (processed by main command)
├── 📁 Subfolder1 → Task Agent 1 (parallel)
├── 📁 Subfolder2 → Task Agent 2 (parallel)
├── 📁 Subfolder3 → Task Agent 3 (parallel)
└── 📁 Subfolder4 → Task Agent 4 (parallel)
```

Each Task agent processes its assigned subfolder independently, including any nested subfolders within it.

### 1. Validate Input and Setup

- Validates the drive-folder-id format
- Creates the base output directory: `designs/specs/`
- Retrieves the root folder name using Zapier MCP

### 2. Retrieve Root Folder Information and Check Permissions

```bash
# Use Zapier MCP to get folder details
# Claude will execute:
mcp__zapier__google_drive_retrieve_file_or_folder_by_id
  - drive: (default drive)
  - id: <drive-folder-id>
  
# Extract folder name for output directory structure

# Check folder sharing permissions
mcp__zapier__google_drive_api_request_beta
  - method: GET
  - url: https://www.googleapis.com/drive/v3/files/<drive-folder-id>
  - querystring: fields=permissions,sharingUser,viewersCanCopyContent
  
# Analyze permissions to determine download strategy:
# - If "anyoneWithLink" permission exists → Use direct download method
# - Otherwise → Use standard API export method
```

### 3. Navigate Folder Structure with Parallel Processing

```bash
# 1. List all items in root folder
mcp__zapier__google_drive_retrieve_files_from_google_drive
  - driveId: (current drive)
  - customQuery: "'<folder-id>' in parents"
  - pageSize: 100

# 2. Separate folders and Google Docs in root
# 3. Process root-level Google Docs directly

# 4. Launch parallel Task agents for each subfolder
# ⚡ PARALLEL EXECUTION: Each subfolder processed concurrently
for each subfolder:
  Task tool with subagent_type: "general-purpose"
  description: "Process Google Drive subfolder"
  prompt: """
    Process Google Drive folder for specification ingestion:
    
    Folder ID: {subfolder_id}
    Folder Name: {subfolder_name}
    Output Path: designs/specs/{root_folder_name}/{subfolder_name}/
    
    Instructions:
    1. Check folder permissions using mcp__zapier__google_drive_api_request_beta
       - If folder has "anyoneWithLink" permission, use curl direct download method
    2. Use mcp__zapier__google_drive_retrieve_files_from_google_drive to list all items
    3. For each Google Doc:
       - Get metadata using mcp__zapier__google_drive_retrieve_file_or_folder_by_id
       - Check if document likely contains images (via metadata or custom instructions)
       - If permissions allow, use curl for direct download:
         * For docs with images: curl -L -o "{filename}.pdf" "https://docs.google.com/feeds/download/documents/export/Export?id={fileId}&exportFormat=pdf"
         * For text-only docs: curl -L -o "{filename}.md" "https://docs.google.com/feeds/download/documents/export/Export?id={fileId}&exportFormat=markdown"
       - Otherwise, fall back to Zapier MCP API methods
       - Save exported content or create placeholder if export fails
    4. Recursively process any subfolders found
    5. Return summary: files exported, export failures, folders traversed, download method used
    
    Custom Instructions: {custom_instructions if provided}
    """
```

### 4. Process Google Docs Files

For each Google Doc found:

```bash
# 1. Get document metadata
mcp__zapier__google_drive_retrieve_file_or_folder_by_id
  - drive: (default drive)
  - id: <file-id>

# 2. Export Google Doc content (methods in priority order based on permissions)

# Method A: Curl Direct Download (if folder has "anyoneWithLink" permission)
# This method provides the best content preservation and bypasses API limitations
# Claude will execute bash command:

# Check if document contains images (based on metadata or custom instructions)
# If images detected or requested:
curl -L -o "{clean_filename}.pdf" \
  "https://docs.google.com/feeds/download/documents/export/Export?id={file-id}&exportFormat=pdf"

# For text-only documents:
curl -L -o "{clean_filename}.md" \
  "https://docs.google.com/feeds/download/documents/export/Export?id={file-id}&exportFormat=markdown"

# Method B: Zapier MCP Direct Download (fallback for public folders)
mcp__zapier__google_drive_api_request_beta
  - method: GET
  - url: https://docs.google.com/document/d/<file-id>/export
  - querystring: format=md (or format=pdf for images)
  - headers: (handled by Zapier authentication)

# Method C: Google Docs specific export (if configured)
mcp__zapier__google_docs_export_document (if configured)
  - document_id: <file-id>
  - format: markdown (or pdf)

# Method D: Drive API export endpoint (final fallback)
mcp__zapier__google_drive_api_request_beta
  - method: GET
  - url: https://www.googleapis.com/drive/v3/files/<file-id>/export
  - querystring: mimeType=text/plain (or application/pdf)
  - headers: (handled by Zapier authentication)

# 3. Create .md file with exported content
# If export succeeds: Save actual document content with proper formatting
# If export fails: Create placeholder with metadata and manual export instructions
```

### 5. Create Markdown Files

```bash
# For each Google Doc:
# 1. Clean up the document name (remove invalid characters)
# 2. Create directory path: designs/specs/{root-folder-name}/{subfolder-path}/
# 3. Write content to: {doc-name}.md

# If content export succeeded:
---
title: {Document Name}
source: Google Docs
file_id: {Google Drive File ID}
last_modified: {Date}
drive_link: https://docs.google.com/document/d/{file-id}/edit
status: EXPORTED
---

# {Document Name}

{Exported content from Google Doc}

---
*Exported from Google Drive on {date}*

# If content export failed (fallback):
---
title: {Document Name}
source: Google Docs
file_id: {Google Drive File ID}
last_modified: {Date}
drive_link: https://docs.google.com/document/d/{file-id}/edit
status: EXPORT_FAILED
error: {Error message}
---

# {Document Name}

> ⚠️ **Automatic Export Failed**
> 
> The API request to export this document failed. Manual export required.
> 
> **Error**: {error details}
> 
> **Manual Export Steps:**
> 1. Click the drive link above
> 2. File → Download → Markdown (.md) or Plain Text (.txt)
> 3. Replace this file with the exported content
```

### 6. Wait for Parallel Tasks and Generate Summary Report

```bash
# Wait for all Task agents to complete
# Collect results from each parallel task

# Generate consolidated report:
# - Total folders processed (including parallel tasks)
# - Total documents converted across all tasks
# - Complete file structure created
# - Any errors or skipped files from any task
# - Performance metrics (time saved through parallelization)
```

## Zapier MCP Functions Used

### Primary Functions

1. **`mcp__zapier__google_drive_retrieve_file_or_folder_by_id`**
   - Get folder/file details by ID
   - Used for: Getting root folder name and verifying items

2. **`mcp__zapier__google_drive_retrieve_files_from_google_drive`**
   - List files in a folder
   - Used for: Navigating folder structure
   - Query: `'<folder-id>' in parents`

3. **`mcp__zapier__google_drive_api_request_beta`**
   - Make authenticated API requests
   - Used for: Exporting Google Docs content
   - Endpoint: `/files/{fileId}/export?mimeType=text/plain`

### Helper Functions

4. **`mcp__zapier__google_drive_find_a_file`**
   - Search for specific files
   - Used when: Custom instructions specify file patterns

5. **`mcp__zapier__google_drive_find_a_folder`**
   - Search for specific folders
   - Used when: Custom instructions specify folder patterns

### Google Docs Specific Functions (if available)

6. **`mcp__zapier__google_docs_find_document`** (if configured)
   - Search specifically for Google Docs documents
   - More targeted than general file search
   - May provide document-specific metadata

7. **`mcp__zapier__google_docs_export_document`** (if configured)
   - Direct export of Google Docs content
   - Alternative to using API request beta
   - May support multiple export formats

## Output Structure

```
designs/specs/
└── {root-folder-name}/
    ├── {doc-name}.md
    ├── {subfolder-1}/
    │   ├── {doc-name}.md
    │   └── {doc-name-2}.md
    └── {subfolder-2}/
        └── {doc-name}.md
```

## Error Handling

- **Invalid Folder ID**: Validates format and existence before processing
- **Access Denied**: Reports files/folders that cannot be accessed
- **Export Failures**: Logs files that cannot be exported and continues
- **Rate Limiting**: Implements delays between API calls if needed
- **Large Folders**: Handles pagination for folders with many items

## Curl Download Implementation

### Direct Download with Curl

When a folder has "anyoneWithLink" permissions, the command uses curl for optimal performance:

```bash
# For each Google Doc in a public folder:

# 1. Determine export format based on content
# Check if document contains images via:
# - Custom instructions (e.g., "download as PDF")
# - Document metadata hints
# - File naming conventions

# 2. Clean filename for filesystem
CLEAN_FILENAME=$(echo "$DOC_NAME" | sed 's/[^a-zA-Z0-9._-]/_/g')

# 3. Execute curl download
if [[ "$HAS_IMAGES" == "true" || "$CUSTOM_INSTRUCTIONS" =~ "PDF" ]]; then
    # Download as PDF to preserve images
    echo "📑 Downloading as PDF (preserves images): $DOC_NAME"
    curl -L -o "${OUTPUT_DIR}/${CLEAN_FILENAME}.pdf" \
        "https://docs.google.com/feeds/download/documents/export/Export?id=${FILE_ID}&exportFormat=pdf"
else
    # Download as Markdown for text-only content
    echo "📝 Downloading as Markdown: $DOC_NAME"
    curl -L -o "${OUTPUT_DIR}/${CLEAN_FILENAME}.md" \
        "https://docs.google.com/feeds/download/documents/export/Export?id=${FILE_ID}&exportFormat=markdown"
fi

# 4. Verify download success
if [[ -f "${OUTPUT_DIR}/${CLEAN_FILENAME}.md" ]] || [[ -f "${OUTPUT_DIR}/${CLEAN_FILENAME}.pdf" ]]; then
    echo "✅ Successfully downloaded: $DOC_NAME"
else
    echo "⚠️  Download failed, falling back to Zapier MCP methods"
    # Fall back to Method B/C/D
fi
```

### Key Benefits of Curl Method

1. **No API Rate Limits**: Direct downloads bypass Google Drive API quotas
2. **No Authentication**: Works with public links without OAuth tokens
3. **Faster Downloads**: Direct HTTP requests are more efficient
4. **Image Preservation**: PDF export maintains all visual content
5. **Batch Processing**: Can run multiple curl commands in parallel

## Implementation Steps

### Step 1: Validate Arguments
```bash
FOLDER_ID="$1"
CUSTOM_INSTRUCTIONS="${2:-}"

# Validate folder ID format
if [[ ! "$FOLDER_ID" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "❌ Error: Invalid folder ID format"
    exit 1
fi
```

### Step 2: Get Root Folder Details
```bash
# Claude executes Zapier MCP function
echo "📁 Retrieving root folder information..."
# mcp__zapier__google_drive_retrieve_file_or_folder_by_id
# Extract folder name from response
```

### Step 3: Create Output Directory
```bash
OUTPUT_BASE="designs/specs/${ROOT_FOLDER_NAME}"
mkdir -p "$OUTPUT_BASE"
echo "📂 Created output directory: $OUTPUT_BASE"
```

### Step 4: Process Root Level and Launch Parallel Tasks
```bash
# Process root folder
echo "📋 Listing items in root folder..."
# mcp__zapier__google_drive_retrieve_files_from_google_drive

# Process root-level Google Docs
echo "📄 Processing root-level documents..."
# For each Google Doc in root: export and save

# Launch parallel tasks for subfolders
echo "🚀 Launching parallel tasks for subfolders..."
# For each subfolder in root:
#   Task tool execution with detailed prompt:
#   - Subfolder ID and path
#   - Output directory path
#   - Custom instructions (if any)
#   - Zapier MCP functions to use
```

### Step 5: Parallel Task Execution (Handled by Task Agents)
```bash
# Each Task agent independently:
# 1. Lists items in assigned subfolder
# 2. Exports Google Docs to markdown
# 3. Recursively processes nested subfolders
# 4. Creates directory structure
# 5. Returns summary of processed items
```

### Step 6: Collect Results and Generate Report
```bash
# Wait for all parallel tasks to complete
# Collect summaries from each task agent
# Generate consolidated report with:
# - Total documents processed
# - Folder structure created
# - Any errors encountered
# - Performance metrics
```

## Requirements

- **Zapier MCP**: Must be configured with Google Drive access
- **Google Drive API**: Proper permissions to read files and folders
- **Write Permissions**: Ability to create files in `designs/specs/` directory

## Limitations and Export Behavior

### 📋 Google Docs Content Export

**Export Methods** (in priority order):

1. **Curl Direct Download** (BEST - for public folders):
   - Checks if folder has "anyoneWithLink" permission
   - Uses curl with Google Docs export URLs that bypass API limitations
   - For documents with images: `curl -L -o file.pdf "https://docs.google.com/feeds/download/documents/export/Export?id={fileId}&exportFormat=pdf"`
   - For text-only documents: `curl -L -o file.md "https://docs.google.com/feeds/download/documents/export/Export?id={fileId}&exportFormat=markdown"`
   - No authentication required for shared documents
   - Preserves all content including images when using PDF format

2. **Zapier MCP Direct Download** (for public folders when curl unavailable):
   - Uses direct Google Docs export via Zapier MCP
   - URL: `https://docs.google.com/document/d/{fileId}/export?format=md` or `format=pdf`
   - Good formatting preservation but requires Zapier authentication

3. **API Export** (for restricted folders):
   - Uses `mcp__zapier__google_drive_api_request_beta` with Google Drive API v3
   - Attempts: `/files/{fileId}/export?mimeType=text/plain` or `application/pdf`
   - Requires proper OAuth permissions

**What the command attempts**:
1. Check folder sharing permissions to determine optimal download strategy
2. Detect if documents contain images (via metadata or custom instructions)
3. For public folders with curl available:
   - Download as PDF if images detected: Preserves all visual content
   - Download as Markdown for text-only: Best for code and documentation
4. For restricted folders: API-based export (plain text or PDF)
5. Save exported content with appropriate file extension (.md or .pdf)

**Success Scenario**:
- ✅ Navigate Google Drive folder structures
- ✅ List all Google Docs in folders
- ✅ Export document content via API
- ✅ Create .md files with actual content
- ✅ Maintain folder structure
- ✅ Process multiple folders in parallel

**Failure Scenarios**:
- ⚠️ API authentication issues → Creates placeholder with error details
- ⚠️ Rate limiting → Creates placeholder, suggests retry
- ⚠️ Unsupported document format → Creates placeholder with manual export steps
- ⚠️ Network errors → Creates placeholder with retry instructions

**Important Notes**:
- Export success depends on Zapier's OAuth token having proper Google Drive API permissions
- Some complex Google Docs formatting may be lost in plain text export
- Large documents may timeout and require manual export

## Notes

- **Curl Downloads**: Primary method for public folders - fast, reliable, no authentication needed
- **Image Detection**: Automatically identifies documents with images and downloads as PDF
- **Export Formats**:
  - **Markdown (.md)**: For text-only documents, code, and documentation
  - **PDF (.pdf)**: For documents with images, diagrams, or complex formatting
- **Authentication**: Falls back to Zapier MCP's built-in Google Drive authentication for restricted folders
- **File Types**: Only processes Google Docs (not Sheets, Slides, etc.)
- **Folder Structure**: Maintains exact folder hierarchy from Google Drive
- **Naming**: Preserves original document names (sanitized for filesystem)
- **Custom Instructions**: 
  - Can force PDF download: "download as PDF"
  - Can specify image detection: "documents contain images"
  - Flexible filtering and processing rules
- **Performance**: 
  - Curl downloads bypass API rate limits entirely
  - Parallel processing of subfolders via Task agents
  - Significant speed improvement for folders with multiple subfolders
  - Each subfolder processed independently and concurrently
- **Google Docs Export URLs**:
  - Markdown: `https://docs.google.com/feeds/download/documents/export/Export?id={ID}&exportFormat=markdown`
  - PDF: `https://docs.google.com/feeds/download/documents/export/Export?id={ID}&exportFormat=pdf`
  - Works without authentication for "anyoneWithLink" shared documents

## Version History

- v1.5.0 - Enhanced with curl-based direct downloads and image-aware PDF export
  - Primary method now uses curl for direct Google Docs downloads
  - Automatically detects documents with images and downloads as PDF
  - Uses `curl -L` with Google Docs export URLs that bypass API limitations
  - Supports both markdown (text-only) and PDF (with images) formats
  - No authentication required for "anyoneWithLink" shared documents
  - Significantly faster and more reliable than API methods
- v1.4.0 - Added permissions-aware download strategy
  - Checks folder sharing permissions before processing
  - Prioritizes direct markdown download for "anyoneWithLink" folders
  - Uses `https://docs.google.com/document/d/{fileId}/export?format=md` for public docs
  - Better content preservation and formatting for publicly accessible documents
  - Falls back to API export for folders with restricted permissions
- v1.3.1 - Added Google Docs specific MCP functions
  - Documented Google Docs specific functions if available in Zapier MCP
  - Added mcp__zapier__google_docs_find_document for targeted search
  - Added mcp__zapier__google_docs_export_document for direct export
  - Provides multiple export methods for better reliability
- v1.3.0 - Restored content export capability using API request beta
  - Uses Google Drive API v3 export endpoint via mcp__zapier__google_drive_api_request_beta
  - Attempts to export Google Docs as text/plain or text/markdown
  - Falls back to placeholder files with error details if export fails
  - Success depends on Zapier OAuth token permissions
- v1.2.0 - Updated to clarify Google Docs content limitation
  - Documented that Zapier MCP cannot export Google Docs content
  - Changed to create placeholder files with metadata and links
  - Added clear workaround instructions for manual export
  - Maintained folder structure creation and parallel processing
- v1.1.0 - Enhanced with parallel subfolder processing using Claude's Task tool
  - Each subfolder in root processed by independent Task agent
  - Significant performance improvement for multi-folder structures
  - Maintains all original functionality with better concurrency
- v1.0.0 - Initial implementation with Zapier MCP integration for Google Drive specification ingestion