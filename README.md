# M4A4 to M4A1-S Replacer

这是一个 SourceMod 插件，用于在 CS:GO 服务器中自动将购买的 M4A4 替换为 M4A1-S，并退还差价。

## 功能

- **自动替换**：当 CT 阵营玩家购买 M4A4 时，自动替换为 M4A1-S。
- **差价退还**：退还 $200 差价（M4A4 $3100 vs M4A1-S $2900）。
- **消息提示**：在聊天栏提示玩家已替换并退款。

## 编译方法

1. 确保你已安装 SourceMod 编译环境（需支持 CS:GO）。
2. 将 `scripting/m4a4_to_m4a1s.sp` 文件放入 `scripting` 目录。
3. 运行 `./spcomp m4a4_to_m4a1s.sp` 进行编译。
4. 编译生成的 `.smx` 文件通常位于 `scripting` 根目录中。

## 安装方法

1. 将编译好的 `m4a4_to_m4a1s.smx` 文件上传到服务器的 `csgo/addons/sourcemod/plugins/` 目录。
2. 重启服务器或在控制台输入 `sm plugins load m4a4_to_m4a1s.smx` 加载插件。

## 配置

插件目前使用硬编码的差价 ($200)。如果需要修改，请编辑源代码中的 `#define REFUND_AMOUNT 200` 并重新编译。

## 依赖

- SourceMod 1.10 或更高版本
- CS:GO
