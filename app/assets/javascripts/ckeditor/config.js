if (typeof(CKEDITOR) != 'undefined') {
  CKEDITOR.editorConfig = function (config) {
    config.toolbar_mini = [
      ["Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript"],
    ];
    config.toolbar = "simple";
  }
}
