# 展示项目部署指南

## 1️⃣ 在GitHub创建新仓库

### 方法1: 通过Web界面
1. 访问 https://github.com/new
2. 填写信息：
   - **Repository name**: `AutoUVM-Showcase`
   - **Description**: `AutoUVM - 自动化UVM验证环境生成工具（展示项目）`
   - **Public** ✅ (选择公开)
   - **不要** 勾选 "Add a README file"
   - **不要** 勾选 "Add .gitignore"
   - **不要** 勾选 "Choose a license"
3. 点击 "Create repository"

### 方法2: 通过GitHub CLI (如果已安装)
```bash
gh repo create AutoUVM-Showcase --public --source=/home/yian/桌面/AutoUVM-Showcase --push
```

## 2️⃣ 推送代码到GitHub

创建仓库后，GitHub会显示推送指令，运行以下命令：

```bash
cd /home/yian/桌面/AutoUVM-Showcase

# 添加远程仓库（替换为你的实际GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/AutoUVM-Showcase.git

# 或使用SSH（如果已配置）
# git remote add origin git@github.com:YOUR_USERNAME/AutoUVM-Showcase.git

# 推送代码
git push -u origin main
```

## 3️⃣ 启用GitHub Pages

1. 访问仓库设置页面：
   ```
   https://github.com/YOUR_USERNAME/AutoUVM-Showcase/settings/pages
   ```

2. 配置 Pages：
   - **Source**: 
     - Branch: `main`
     - Folder: `/ (root)`
   - 点击 **Save**

3. 等待1-2分钟，页面会显示：
   ```
   Your site is published at https://YOUR_USERNAME.github.io/AutoUVM-Showcase/
   ```

## 4️⃣ 更新联系方式

编辑 `README.md`，更新以下信息：

```markdown
### 联系方式

- **📧 邮箱**: your_email@example.com  ← 改成真实邮箱
- **💬 微信**: YourWeChatID           ← 改成真实微信
- **📱 电话**: +86 XXX-XXXX-XXXX      ← 改成真实电话
```

然后提交并推送：
```bash
git add README.md
git commit -m "docs: 更新联系方式"
git push
```

## 5️⃣ 验证网站

访问你的GitHub Pages网站：
```
https://YOUR_USERNAME.github.io/AutoUVM-Showcase/
```

检查：
- ✅ 首页正常显示
- ✅ 所有链接可以点击
- ✅ 移动端显示正常
- ✅ GitHub角标指向正确仓库

## 6️⃣ 后续更新

### 添加截图/GIF
```bash
cd /home/yian/桌面/AutoUVM-Showcase/assets

# 创建子目录
mkdir -p screenshots gifs branding thumbnails

# 复制你的截图（录制视频后）
cp /path/to/your/screenshot.png screenshots/

# 在README中引用
# ![Demo](assets/screenshots/demo.png)

git add assets/
git commit -m "docs: 添加演示截图"
git push
```

### 添加视频链接
录制完视频并上传到YouTube/Bilibili后：

1. 编辑 `README.md`，在 "📺 快速演示" 部分：
```markdown
### 视频演示
- 🎬 [Timer快速入门 (5分钟)](https://youtube.com/watch?v=xxxxx)
- 🎬 [AXI4 DMA控制器验证 (8分钟)](https://youtube.com/watch?v=xxxxx)
- 🎬 [覆盖率驱动验证 (6分钟)](https://youtube.com/watch?v=xxxxx)
```

2. 提交更新：
```bash
git add README.md
git commit -m "docs: 添加Demo视频链接"
git push
```

## 7️⃣ 宣传推广

### 更新原仓库README
在你的私有 `AutoUVM` 仓库的 README 顶部添加：

```markdown
> **🌐 展示网站**: https://YOUR_USERNAME.github.io/AutoUVM-Showcase/
> 
> 本仓库为私有开发仓库。公开展示材料请访问上述网站。
```

### 社交媒体分享
- LinkedIn: 分享网站链接
- 知乎: 写技术文章并附带链接
- CSDN: 发布博客
- Reddit: r/FPGA, r/ASIC
- Hacker News: Show HN

### SEO优化
在 `index.html` 的 `<head>` 中已包含：
- Meta描述
- 关键词
- Open Graph标签（可选添加）

## 📊 项目结构总结

```
AutoUVM-Showcase/  (公开展示仓库)
├── README.md              ← 完整产品介绍
├── index.html            ← GitHub Pages网站
├── _config.yml           ← Jekyll配置
├── LICENSE               ← 商业授权说明
├── .gitignore
└── assets/               ← 媒体资源
    ├── screenshots/
    ├── gifs/
    ├── branding/
    └── thumbnails/

AutoUVM/  (私有开发仓库，保持私有)
├── autouvm3/             ← 核心代码
├── examples/             ← 示例代码
├── docs/                 ← 技术文档
└── tests/                ← 测试代码
```

## ✅ 检查清单

部署前检查：
- [ ] GitHub新仓库已创建 (AutoUVM-Showcase)
- [ ] 代码已推送到GitHub
- [ ] GitHub Pages已启用
- [ ] 网站可以正常访问
- [ ] README中的联系方式已更新
- [ ] README中的链接都正确指向新仓库
- [ ] LICENSE文件已审核

后续任务：
- [ ] 录制Demo视频
- [ ] 添加视频链接到README
- [ ] 上传截图和GIF
- [ ] 创建Logo和品牌资源
- [ ] 准备宣传材料
- [ ] 社交媒体推广

---

## 🎯 核心理念

**展示和代码分离**：
- ✅ **AutoUVM-Showcase** (公开): 产品展示、营销、获客
- ✅ **AutoUVM** (私有): 核心代码、技术积累、IP保护

这样既能：
1. 通过公开展示吸引客户
2. 保护核心技术不被复制
3. 维护专业的商业形象
4. 灵活控制信息披露

完美的商业策略！🚀
