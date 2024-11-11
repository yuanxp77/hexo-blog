({
  // Please visit the URL below for more information:
  // https://shd101wyy.github.io/markdown-preview-enhanced/#/extend-parser

  onWillParseMarkdown: async function (markdown) {
    markdown = markdown.replace(
        /\{%\s*asset_img\s*(.*)\s*%\}/g,
        (whole, content) => {
            [imgPath, altText] = content.split(" ");
            // console.log("imgPath:", imgPath);
            // console.log("altText:", altText);
            // 说明：这里借助图片描述(altText)参数来表示md的文件名，因为markdown的语法需要用相对路径。
            result = `![](${altText}/${imgPath})`
            // console.log("result:", result);
            return result;
        }
    );
    return markdown;
},

  onDidParseMarkdown: async function(html) {
    return html;
  },
})