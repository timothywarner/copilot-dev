# GitHub Copilot for Developers - Teaching Punchlist (Sept 2025)

## Course Structure
- **Duration**: 4 hours total
- **Segments**: 4 x ~55 minute segments
- **Breaks**: ~9 minute breaks between segments
- **Platform**: ON24 live training

## SEGMENT 1: Enablement & Core Features (55min)

### 1. Welcome & Setup (10min)
- [ ] MVP/MCT intro
- [ ] Repo link: `https://github.com/timothywarner/copilot-dev`
- [ ] Check: Enterprise plan active, VS Code 1.102+
- [ ] Enable MCP if org allows
- [ ] Verify extensions: Copilot + Chat installed

### 2. Responsible AI (10min)
- [ ] Key risks: hallucinations, IP, security
- [ ] DEMO: Public code filter ON/OFF
- [ ] Show duplicate detection (65+ lexemes)
- [ ] Validation best practices
- [ ] Data privacy: No training on Business/Enterprise

### 3. Completions & Chat Basics (15min)
- [ ] DEMO: Tab completions (single/multi-line)
- [ ] DEMO: Chat panel vs inline chat
- [ ] Keyboard shortcuts: Tab, Alt+], Ctrl+Enter
- [ ] Accept/reject/cycle suggestions
- [ ] DEMO: `/explain`, `/fix`, `/test` commands

### 4. Models & Context (15min)
- [ ] Switch models: o1, GPT-4o, Claude 3.5
- [ ] DEMO: Compare outputs between models
- [ ] Context sources: open files, workspace, symbols
- [ ] DEMO: `#file`, `#selection`, `#workspace`
- [ ] Reference KB: `@knowledge-base:NAME`

### 5. Q&A (5min)
- [ ] Address questions
- [ ] Preview next segment

## BREAK 1 (9min)

## SEGMENT 2: Customization & Knowledge (55min)

### 1. Chat Modes & Agent (15min)
- [ ] DEMO: Edit mode - multi-file changes
- [ ] DEMO: Agent mode - autonomous workflows
- [ ] Show: Assign issue to @copilot
- [ ] Agent creates branch, PR, runs tests
- [ ] Mobile & CLI agent access

### 2. Custom Instructions (15min)
- [ ] Create `.github/copilot-instructions.md`
- [ ] DEMO: Path-scoped `*.instructions.md`
- [ ] Show `applyTo:` with globs
- [ ] AGENTS.md for coding agent
- [ ] DEMO: Apply coding standards

### 3. Knowledge Bases (15min)
- [ ] Create KB on GitHub.com
- [ ] Add repos, docs, wikis
- [ ] DEMO: Query KB in chat
- [ ] VS Code: Reference with `@knowledge-base`
- [ ] Limitations: 10 KBs, 20 repos each

### 4. Web Integration (10min)
- [ ] Chat on GitHub.com
- [ ] DEMO: PR summaries auto-generate
- [ ] Code review with custom instructions
- [ ] Issue to code workflow
- [ ] Mobile app features

## BREAK 2 (9min)

## SEGMENT 3: Governance & Security (55min)

### 1. Organization Policies (15min)
- [ ] Enable/disable features per org
- [ ] DEMO: Manage via REST API
- [ ] Seat management & assignment
- [ ] Enterprise Teams (public preview)
- [ ] Content exclusions setup

### 2. Public Code Matches (10min)
- [ ] DEMO: Duplication filter settings
- [ ] Show blocked suggestion example
- [ ] 65+ lexeme threshold
- [ ] Admin controls at enterprise/org level
- [ ] IP indemnity (Business/Enterprise)

### 3. Metrics API (15min)
- [ ] Access: `/copilot/metrics` endpoint
- [ ] Required scopes: `manage_billing:copilot`
- [ ] DEMO: Acceptance rate, daily active users
- [ ] Team-level metrics (new)
- [ ] Copilot Metrics Viewer tool

### 4. Audit & Compliance (10min)
- [ ] Audit log events
- [ ] DEMO: Search copilot.* events
- [ ] Data retention: 28 days prompts, 0 days code
- [ ] SOC 2, ISO compliance
- [ ] GDPR considerations

### 5. Q&A (5min)

## BREAK 3 (9min)

## SEGMENT 4: Extensions & Future (55min)

### 1. Model Context Protocol (15min)
- [ ] DEMO: Configure `.vscode/mcp.json`
- [ ] Connect GitHub MCP server
- [ ] Show tools, resources, prompts
- [ ] Security: Only trusted sources
- [ ] IDE support: VS Code, JetBrains, Xcode, Eclipse

### 2. Extensions Ecosystem (15min)
- [ ] GitHub Apps for Copilot
- [ ] DEMO: Install from marketplace
- [ ] VS Code extensions integration
- [ ] Custom tool development basics
- [ ] API integration patterns

### 3. CLI & Automation (10min)
- [ ] Install: `gh extension install github/copilot`
- [ ] DEMO: `gh copilot explain/suggest`
- [ ] Shell integration (bash, zsh, PowerShell)
- [ ] Scripting with Copilot
- [ ] CI/CD integration possibilities

### 4. Road Ahead & Wrap (15min)
- [ ] Spark multi-file planning (coming)
- [ ] Enhanced agent capabilities
- [ ] Fine-tuned models (Enterprise)
- [ ] Workspace-wide understanding
- [ ] Resources & certification path
- [ ] Contact: tim@techtrainertim.com

## Post-Session
- [ ] Share slides
- [ ] Update repo with demos
- [ ] Follow up on unanswered questions

## Key Demos Ready
1. Agent mode: Issue → PR workflow
2. Custom instructions with path scoping
3. Knowledge Base creation & query
4. MCP server connection
5. Metrics API visualization
6. Public code filter comparison
7. Multi-model output comparison
8. CLI automation example

## Backup Plans
- Pre-recorded agent demo if slow
- Local KB examples if web down
- Screenshots of metrics dashboard
- Offline instruction files ready