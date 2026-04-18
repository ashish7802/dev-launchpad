<!-- dev-launchpad/README.md -->

<div align="center">

# 🚀 Dev Launchpad

**The ultimate developer productivity toolkit. Scripts, templates, prompts, and curated tools—all in one place.**

[![Stars](https://img.shields.io/github/stars/ashish7802/dev-launchpad?style=for-the-badge&logo=github&color=yellow)](https://github.com/ashish7802/dev-launchpad/stargazers)
[![Forks](https://img.shields.io/github/forks/ashish7802/dev-launchpad?style=for-the-badge&logo=github&color=blue)](https://github.com/ashish7802/dev-launchpad/network)
[![License](https://img.shields.io/github/license/ashish7802/dev-launchpad?style=for-the-badge&color=green)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](CONTRIBUTING.md)

[🚀 Quick Start](#quick-start) • [📁 Structure](#folder-structure) • [📖 Docs](docs/) • [🤝 Contribute](CONTRIBUTING.md)

</div>

---

## 🎯 What is this?

**Dev Launchpad** is a curated collection of battle-tested developer resources designed to eliminate repetitive setup work and accelerate your workflow. Whether you're spinning up a new project, debugging production issues, or standardizing your team's code review process—this toolkit has you covered.

Think of it as your **developer Swiss Army knife**: always there when you need it, surprisingly comprehensive, and constantly improving thanks to community contributions.

### What's inside?

| Category | Contents | Best For |
|----------|----------|----------|
| 🛠️ **Scripts** | 25+ CLI automations (Git, Docker, NPM, Linux) | Daily devops tasks |
| 📦 **Templates** | Production-ready starters (Node, Python, Next.js, FastAPI, React) | New projects in < 60 seconds |
| 🤖 **Prompts** | 30+ AI prompts for coding tasks | Pair programming with AI |
| ✅ **Checklists** | Review & deployment checklists | Quality assurance |
| 🔧 **Tools** | Curated lists by category | Discovering the right tool for the job |

---

## 💡 Why use it?

### Stop reinventing the wheel
Every developer has a `~/scripts` folder full of one-off hacks. We've collected, tested, and standardized the best ones—so you don't have to.

### Ship faster
Our templates aren't "hello world" demos. They include testing, linting, CI/CD configs, and security best practices from day one.

### Code with confidence
Review checklists used by teams at scale. AI prompts refined through thousands of real-world coding sessions.

### Community-driven
This isn't a personal dotfiles repo. It's a **living resource** maintained by developers who actually use these tools daily.

> *"I used to spend 2 hours setting up a new FastAPI project. Now it's 30 seconds and I'm writing actual business logic."*  
> — Early contributor

---

## 📁 Folder Structure

```
dev-launchpad/
├── 📜 scripts/          # CLI automations
│   ├── git/            # Sync forks, cleanup branches, commit helpers
│   ├── docker/         # Cleanup, dev envs, volume backups
│   ├── npm/            # Dependency management, publishing
│   └── linux/          # System utilities, SSH, monitoring
│
├── 📦 templates/        # Project starters
│   ├── nodejs/         # Express + Jest + ESLint
│   ├── python/         # Modern packaging with pyproject.toml
│   ├── nextjs/         # App Router + Tailwind + TypeScript
│   ├── fastapi/        # Async SQL + Alembic + Docker
│   └── react/          # Vite + modern hooks setup
│
├── 🤖 prompts/          # AI prompt library
│   ├── debug/          # Error analysis, stack traces, memory leaks
│   ├── refactor/       # Clean code, TypeScript migration
│   ├── review/         # Security audits, architecture review
│   ├── explain/        # Complex logic breakdown
│   ├── optimize/       # Query optimization, bundle size
│   └── generate/       # Tests, docs, API scaffolding
│
├── ✅ checklists/       # Process standardization
│   ├── code-review/    # Frontend, backend, fullstack
│   ├── deployment/     # Pre-deploy, rollback procedures
│   ├── security/       # Auth, secrets, dependency audit
│   └── performance/    # Optimization, load testing
│
├── 🔧 tools/            # Curated tool directories
│   ├── development/    # Editors, terminals, version control
│   ├── frontend/       # Frameworks, build tools, testing
│   ├── backend/        # Runtimes, databases, message queues
│   ├── devops/         # CI/CD, containers, IaC
│   ├── design/         # UI tools, prototyping, assets
│   ├── productivity/   # Note-taking, API clients, docs
│   └── ai-ml/          # Model platforms, vector DBs, coding assistants
│
└── 📖 docs/             # Comprehensive guides
    ├── guides/         # Getting started, customization
    ├── contributing/   # Setup, PR guidelines
    ├── roadmap/        # Quarterly plans, long-term vision
    └── faq/            # Troubleshooting, common questions
```

---

## 🚀 Quick Start

### Option 1: Clone and explore
```bash
git clone https://github.com/ashish7802/dev-launchpad.git
cd dev-launchpad
```

### Option 2: Use specific components
```bash
# Copy just the template you need
cp -r dev-launchpad/templates/fastapi ./my-new-api
```

### Option 3: Symlink for regular use
```bash
# Add scripts to your PATH without copying
ln -s $(pwd)/dev-launchpad/scripts/git/* ~/.local/bin/
```

---

## 🛠️ How to Use

### Scripts
All scripts are self-documenting. Run with `--help` or no arguments:

```bash
./scripts/git/git-cleanup-branches.sh --help
```

> **Pro tip:** Many scripts support `--dry-run` to preview changes before execution.

### Templates
Each template is production-ready out of the box:
- ✅ Testing framework configured
- ✅ Linting & formatting rules
- ✅ Git hooks for quality gates
- ✅ GitHub Actions CI template
- ✅ Security best practices

### Prompts
Copy → Paste into ChatGPT/Claude/Copilot → Replace `[BRACKETED]` variables.

### Checklists
Use as GitHub task lists, Notion pages, or printed runbooks.

---

## 🤝 Contributing

We welcome contributions from developers of all levels.

| Skill Level | Contribution |
|-------------|-------------|
| Beginner | Fix typos, improve docs, add tool descriptions |
| Intermediate | New shell scripts, template improvements, prompt refinements |
| Advanced | New template categories, CI/CD enhancements, architecture decisions |

**First time contributing?** Check out issues labeled `good first issue`.

---

## 🗺️ Roadmap

### Near Term
- [ ] Add Rust and Go templates
- [ ] Kubernetes scripts collection
- [ ] VS Code extension for prompt snippets

### Later
- [ ] Web interface for browsing templates
- [ ] AI prompt versioning system
- [ ] Community ratings for tools and prompts

---

## 📜 License

MIT License — see [LICENSE](LICENSE) for details. Commercial use welcome.

---

<div align="center">

Made with ❤️ by the community

**[⭐ Star this repo](https://github.com/ashish7802/dev-launchpad)** if it saved you time.

*Built by developers, for developers.*

</div>
