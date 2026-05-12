---
name: claw-remote-takeover
description: 一键把当前 agent 切到「远程化身」模式：检查/创建 MEMORY.md、注入三条死命令、引导开 Gateway、切 bypassPermissions 权限模式、输出"远程化身就位"确认。当用户提到「切远程模式」「Claw 接管」「远程化身」「方法论开场白」时触发。
agent_created: true
---

# claw-remote-takeover

把当前 agent 转换为「远程化身」状态，让用户能从手机小程序继续指挥它干活。

## 触发场景

- 用户说「切远程模式」「开远程协作」「Claw 接管」「让我手机也能用」
- 用户说「我要出门 / 出差 / 离开工位继续干」
- 用户问"怎么远程指挥你"

## 执行流程

### Step 1 · 自检并准备记忆文件

检查当前工作目录下是否有 `.workbuddy/memory/`，没有就创建：

```bash
mkdir -p .workbuddy/memory
```

读取 `.workbuddy/memory/MEMORY.md`（如果存在）。**如果没有，按下面模板创建**；**如果存在但没有「🔒 死命令」区块，自动补到顶部**。

### Step 2 · 注入死命令模板

`MEMORY.md` 顶部必须有此区块（如已有则跳过，不要重复写）：

```markdown
# MEMORY.md

跨会话长期记忆。在这里记录稳定的用户偏好、项目约定，而不是单次任务进度。

## 🔒 死命令（最高优先级·不许越线）

以下三条是用户明令永久生效的硬约束。任何会话、任何上下文、任何借口都不许违背。`bypassPermissions` 权限模式不豁免这三条。

1. **没用户明说，不删 `.workbuddy/memory/` 以外的任何本地文件**。包括但不限于代码文件、配置文件、用户 Home 目录、桌面、Downloads。删 = 必须用户在当次对话里明确说"删 XX"。`rm`、`rm -rf`、`mv 到 /tmp`、`git clean -fd` 等同视为删除。
2. **不动云函数、不删数据库、不动 GitHub 仓库结构性设置**。读取 + 内容更新可以，结构性删改（删函数/删 Gist/删 repo/改分支保护/改可见性）一律 STOP 报用户。
3. **跑 bash 命令前，先用一行话告诉用户要跑什么**。哪怕 `acceptEdits` 或 `bypassPermissions` 模式下也照做。格式示例：「我要跑 `python3 deploy.py xxx`（部署到 GitHub Pages）」。这样用户在小程序里看到命令就能立刻喊停。

违反任意一条都属于严重事故，必须立即停止动作并向用户报告。

---
```

### Step 3 · 引导用户开 Gateway

提示用户：

> 准备好了。最后两件事你需要在 CodeBuddy 里手动做：
>
> 1. 发 `/gateway tunnel`  → 出二维码 → 手机微信扫码绑定 WorkBuddy 小程序
> 2. 发 `/config set permissions.mode bypassPermissions` → 把权限放开
>
> 完成后告诉我"好了"，我就用远程化身的姿态待命。

### Step 4 · 进入"待命"姿态

用户说"好了"后，输出：

```
✅ 远程化身就位。

身份：[当前项目名] 远程化身
工作目录：[cwd]
当前权限：bypassPermissions
死命令：已生效（不删 memory 外文件 / 不动云资源 / 跑 bash 前先报告）

你现在可以关电脑去做别的事。手机微信 → WorkBuddy 小程序 → Claw 入口 → 直接发指令，我接到。

完成任何实质工作我都会立刻写到今天的 .workbuddy/memory/YYYY-MM-DD.md，电脑前那个我重启也能接住。
```

## 注意

- 这个 skill 只做"配置 + 引导"，**不实际执行 `/gateway` 或 `/config` 斜杠命令**——那些必须由 CodeBuddy CLI 本身处理
- 死命令模板可以让用户在 step 2 后微调（比如加更多保护文件/资源），但**不要主动删减三条核心**
- 如果用户已经在远程指挥模式下（即从小程序进入），不需要再触发这个 skill，直接干活即可
