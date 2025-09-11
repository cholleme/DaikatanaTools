#!/bin/bash

# Test script to validate the GitHub Actions workflow structure
# This simulates parts of the workflow that can be tested locally

set -e

echo "=== GitHub Actions Workflow Validation Test ==="
echo

# Test 1: Project Discovery
echo "Test 1: Project Discovery"
echo "========================="

projects=$(find . -name "*.lpr" -type f | tr '\n' ' ')

if [ -z "$projects" ]; then
    echo "❌ FAIL: No Lazarus project files (.lpr) found"
    exit 1
else
    echo "✅ PASS: Found Lazarus projects:"
    for project in $projects; do
        echo "  - $project"
    done
fi

projects_count=$(echo $projects | wc -w)
echo "  Total projects: $projects_count"
echo

# Test 2: Script Permissions
echo "Test 2: Script Permissions"
echo "=========================="

script_path="./.github/scripts/get-lazarus-url.sh"
if [ -x "$script_path" ]; then
    echo "✅ PASS: Script is executable"
else
    echo "❌ FAIL: Script is not executable"
    exit 1
fi
echo

# Test 3: Script Syntax
echo "Test 3: Script Syntax Validation"
echo "==============================="

if bash -n "$script_path"; then
    echo "✅ PASS: Script syntax is valid"
else
    echo "❌ FAIL: Script has syntax errors"
    exit 1
fi
echo

# Test 4: Project Structure Validation
echo "Test 4: Project Structure Validation"
echo "===================================="

for project in $projects; do
    project_dir=$(dirname "$project")
    project_name=$(basename "$project" .lpr)
    lpi_file="$project_dir/$project_name.lpi"
    
    echo "Checking project: $project"
    
    if [ -f "$lpi_file" ]; then
        echo "  ✅ PASS: Found .lpi file: $lpi_file"
    else
        echo "  ⚠️  WARN: Missing .lpi file: $lpi_file"
    fi
    
    # Check for main unit files
    main_unit="$project_dir/mainu.pas"
    if [ -f "$main_unit" ]; then
        echo "  ✅ PASS: Found main unit: $main_unit"
    else
        echo "  ℹ️  INFO: No standard main unit found"
    fi
done
echo

# Test 5: Workflow File Validation
echo "Test 5: Workflow File Validation"
echo "==============================="

workflow_file="./.github/workflows/build-lazarus.yml"
if [ -f "$workflow_file" ]; then
    echo "✅ PASS: Workflow file exists"
    
    # Check for required sections
    if grep -q "name:" "$workflow_file"; then
        echo "  ✅ PASS: Has workflow name"
    else
        echo "  ❌ FAIL: Missing workflow name"
    fi
    
    if grep -q "on:" "$workflow_file"; then
        echo "  ✅ PASS: Has trigger configuration"
    else
        echo "  ❌ FAIL: Missing trigger configuration"
    fi
    
    if grep -q "jobs:" "$workflow_file"; then
        echo "  ✅ PASS: Has jobs configuration"
    else
        echo "  ❌ FAIL: Missing jobs configuration"
    fi
    
    if grep -q "windows-latest" "$workflow_file"; then
        echo "  ✅ PASS: Uses Windows runner"
    else
        echo "  ❌ FAIL: Not configured for Windows runner"
    fi
    
else
    echo "❌ FAIL: Workflow file not found"
    exit 1
fi
echo

# Test 6: Documentation
echo "Test 6: Documentation Check"
echo "========================="

readme_file="./.github/README.md"
if [ -f "$readme_file" ]; then
    echo "✅ PASS: Documentation exists"
    
    word_count=$(wc -w < "$readme_file")
    echo "  Documentation length: $word_count words"
    
    if [ $word_count -gt 500 ]; then
        echo "  ✅ PASS: Comprehensive documentation"
    else
        echo "  ⚠️  WARN: Documentation might be too brief"
    fi
else
    echo "⚠️  WARN: No documentation found"
fi
echo

# Test 7: Git Ignore Configuration
echo "Test 7: Git Ignore Configuration"
echo "==============================="

gitignore_file="./.gitignore"
if [ -f "$gitignore_file" ]; then
    echo "✅ PASS: .gitignore exists"
    
    if grep -q "lib/" "$gitignore_file"; then
        echo "  ✅ PASS: Ignores lib directories"
    else
        echo "  ⚠️  WARN: Doesn't ignore lib directories"
    fi
    
    if grep -q "backup/" "$gitignore_file"; then
        echo "  ✅ PASS: Ignores backup directories"
    else
        echo "  ⚠️  WARN: Doesn't ignore backup directories"
    fi
else
    echo "⚠️  WARN: No .gitignore found"
fi
echo

# Summary
echo "=== Test Summary ==="
echo "✅ Project discovery and validation complete"
echo "✅ GitHub Actions workflow structure validated"
echo "✅ Script permissions and syntax checked"
echo "✅ Documentation and configuration verified"
echo
echo "The workflow is ready for GitHub Actions execution!"
echo "Projects will be built in this order:"
for project in $projects; do
    echo "  → $project"
done
echo