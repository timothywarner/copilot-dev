# Contributing to Windows Server 2025 Learning Lab

Thank you for considering contributing to the Windows Server 2025 Learning Lab project! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to abide by its [Code of Conduct](CODE_OF_CONDUCT.md).

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers understand your report, reproduce the behavior, and find related reports.

**Before Submitting A Bug Report:**

* Check the [troubleshooting guide](docs/troubleshooting.md) for a list of common issues and solutions.
* Check if the bug has already been reported in the Issues section.

**How to Submit A Good Bug Report:**

Bugs are tracked as GitHub issues. Create an issue and provide the following information:

* Use a clear and descriptive title.
* Describe the exact steps to reproduce the problem.
* Provide specific examples to demonstrate the steps.
* Describe the behavior you observed after following the steps.
* Explain which behavior you expected to see instead and why.
* Include screenshots if possible.
* Include details about your environment:
  * OS version
  * Azure region
  * PowerShell version
  * Azure CLI version

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

**Before Submitting An Enhancement Suggestion:**

* Check if the enhancement has already been suggested in the Issues section.
* Check if the functionality already exists in a recent version.

**How to Submit A Good Enhancement Suggestion:**

Enhancement suggestions are tracked as GitHub issues. Create an issue and provide the following information:

* Use a clear and descriptive title.
* Provide a detailed description of the suggested enhancement.
* Provide specific examples to demonstrate how the enhancement would be used.
* List any benefits of the enhancement.
* List any potential drawbacks of the enhancement.

### Pull Requests

* Fill in the required template.
* Do not include issue numbers in the PR title.
* Include screenshots or animated GIFs in your pull request whenever possible.
* Follow the style guide.
* Include relevant tests.
* Document new code.
* Avoid platform-dependent code.

## Style Guide

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature").
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...").
* Limit the first line to 72 characters or less.
* Reference issues and pull requests liberally after the first line.
* Consider starting the commit message with an applicable emoji:
    * 🎨 `:art:` when improving the format/structure of the code
    * 🐎 `:racehorse:` when improving performance
    * 🔒 `:lock:` when dealing with security
    * 📝 `:memo:` when writing docs
    * 🐛 `:bug:` when fixing a bug
    * 🔥 `:fire:` when removing code or files
    * ✅ `:white_check_mark:` when adding tests
    * ⬆️ `:arrow_up:` when upgrading dependencies

### PowerShell Style Guide

* Use proper PowerShell verb-noun command naming.
* Comment your code, especially complex logic.
* Use [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) to check your code quality.
* Use proper error handling with try/catch blocks.
* Follow [PowerShell Best Practices](https://github.com/PoshCode/PowerShellPracticeAndStyle).

### Bicep Style Guide

* Use descriptive names for resources, parameters, and variables.
* Add comments to explain complex deployments.
* Group related resources together.
* Use modules for reusable components.
* Follow [Azure Resource Naming Conventions](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

## Development Workflow

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes.
4. Commit your changes with a clear commit message.
5. Push your branch to your fork.
6. Submit a pull request to the main repository.

## Testing

Before submitting a pull request, ensure that:

1. The deployment works on a clean Azure subscription.
2. All scripts run without errors.
3. The environment functions as expected after deployment.

## Documentation

* Update the README.md with details of changes to the interface.
* Update the docs folder with any new information.
* Maintain the troubleshooting guide with any new issues and solutions you discover.

## Additional Notes

### Issue and Pull Request Labels

This project uses labels to categorize issues and pull requests:

* `bug` - Something isn't working
* `documentation` - Improvements or additions to documentation
* `enhancement` - New feature or request
* `good first issue` - Good for newcomers
* `help wanted` - Extra attention is needed
* `question` - Further information is requested

## Thank You!

Your contributions are greatly appreciated. Every little bit helps, and credit will always be given. 