using System;
using System.IO;
using System.Linq;
using SixLabors.Fonts;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Drawing.Processing;
using SixLabors.ImageSharp.Processing;

if (args.Length < 2) {
 Console.WriteLine("Usage: quoteApp <quote> <author>");
 return;
}

var quoteLines = args[0].Split("\\n");
var qlincnt = quoteLines.Length;

var authorLines = args[1].Split("\\n");
var alincnt = authorLines.Length;
authorLines[0] = "~ " + authorLines[0];

var collection = new FontCollection();
var quoteFamily = collection.Add("DejaVuSerif.ttf");
var authorFamily = collection.Add("NotoSerif-Light.ttf");
var quoteFont = quoteFamily.CreateFont(64);
var authorFont = authorFamily.CreateFont(30);

var quotationLeftSize = TextMeasurer.MeasureAdvance(new ReadOnlySpan<char>("“".ToCharArray()), new TextOptions(quoteFont));
//var quotationRightSize = TextMeasurer.MeasureAdvance(new ReadOnlySpan<char>("”".ToCharArray()), new TextOptions(quoteFont));

var qrects = new List<FontRectangle>();
var arects = new List<FontRectangle>();
var twidth = 0f;
var theight = 0f;
foreach (var qline in quoteLines) {
 var rect = TextMeasurer.MeasureAdvance(new ReadOnlySpan<char>(qline.ToCharArray()), new TextOptions(quoteFont));
 twidth = Math.Max(twidth, rect.Width);
 theight += rect.Height + 2;
 qrects.Add(rect);
}
theight += 10;
foreach (var aline in authorLines) {
 var rect = TextMeasurer.MeasureAdvance(new ReadOnlySpan<char>(aline.ToCharArray()), new TextOptions(authorFont));
 twidth = Math.Max(twidth, rect.Width);
 theight += rect.Height + 1;
 arects.Add(rect);
}

int width = 1920;
int height = 1080;

using (Image image = new Image<Rgba32>(width, height)) {
 image.Mutate(ctx => {
  var textOpts = new DrawingOptions();
  textOpts.GraphicsOptions.Antialias = true;

  // Fill background with black color
  ctx.Fill(new Rgba32(0, 0, 0));

  var cvert = 0f;
  var qind = 0;

  // Draw quote text
  foreach (var qline in quoteLines) {
   var move = 0f;
   if (qind == 0) move = -quotationLeftSize.Width;
   var text = (qind == 0 ? "“" : "") + qline + (qind == qlincnt - 1 ? "”" : "");
   ctx.DrawText(textOpts, text, quoteFont, Color.White, new PointF(width / 2 - qrects[qind].Width / 2 + move, height / 2 - theight / 2 + cvert));
   cvert += qrects[qind++].Height + 2;
  }

  var aind = 0;
  cvert += 10;
  
  // Draw author text
  foreach (var aline in authorLines) {
   ctx.DrawText(textOpts, aline, authorFont, Color.White, new PointF(width / 2 + twidth / 2 - arects[aind].Width, height / 2 - theight / 2 + cvert));
   cvert += arects[aind++].Height + 1;
  }
 });

 string outputPath = "/app/out";
 int idx = FindNextIndex(outputPath);

 string newFileName = $"quote{idx}.png";
 string newPath = Path.Combine(outputPath, newFileName);
 image.Save(newPath);
}

static int FindNextIndex(string folderPath) {
 string?[] existingFiles = Directory.GetFiles(folderPath, "quote*.png").Select(Path.GetFileName).ToArray();

 int idx = 0;
 while (existingFiles.Any(file => file?.Equals($"quote{idx}.png") ?? false)) idx++;

 return idx;
}