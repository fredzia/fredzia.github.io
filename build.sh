#!/bin/bash

# Directory where Markdown files are located
markdown_dir="./diario"

# Output HTML file
output_html="index.html"

# Navbar HTML file
navbar_html="navbar.html"

# Start of HTML content
cat <<EOF > "${output_html}"
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>frdz</title>
    <meta name="keywords" content="fredzia">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--<link href="https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap" rel="stylesheet"> -->
        <style>
        @font-face {
          font-family: 'Roboto Mono'; font-style: normal; font-weight: 400;
          src: local(''),
            url('../include/roboto-mono-v21-latin-regular.woff2') format('woff2'),
            url('../include/roboto-mono-v21-latin-regular.woff') format('woff'); }
        body {background-color:#222; max-width:800px; color:#fff; line-height: 1.6;
          font-family: 'Roboto Mono', monospace; font-size: 1.0em;
          margin:40px auto; padding: 0 10px;}
        code {font-size: 1.6em; color:#999;}
        h1 {font-weight:bold; font-size: 1.6em; margin-top:2em;}
        hr {margin-top: 4em; border: none; background-color: #555; color: #555; height: 1px;}
        a {color:#aaa;}
        a:hover {color:#ccc;}
        img {margin-top: 4em; margin-bottom: 2em; max-width:100%;}
        input {font-family: inherit;}
        nav {background-color: #333; padding: 10px;}
        nav ul {list-style-type: none; padding: 0; margin: 0; text-align: center;}
        nav ul li {display: inline;}
        nav ul li a {color: #fff; text-decoration: none; padding: 10px;}
        nav ul li a:hover {background-color: #555;}
    </style>
</head>
<body>
<br/>
<!-- Include Navbar -->
$(cat "${navbar_html}")

<br/>
EOF

# Function to extract numeric prefix from filename
get_numeric_prefix() {
    filename=$(basename "$1")
    echo "${filename%%[^0-9]*}"
}

# Iterate over Markdown files in the directory
# Use a custom sorting technique to sort by numeric prefix in descending order
for file in $(ls "${markdown_dir}"/*.md | sort -nr -k1.4); do
    # Get publication date from the file (for example purpose)
    pub_date=$(date -r "${file}" "+%m/%d/%y")

    # Extract filename without directory and extension
    filename=$(basename "${file}")
    filename_no_ext="${filename%.*}"

    # Extract numeric prefix from filename
    numeric_prefix=$(get_numeric_prefix "${filename}")

    # Convert Markdown to HTML using cmark
    html_content=$(cmark "${file}")

    # Write HTML content for each Markdown file
    cat <<EOF >> "${output_html}"
<hr />
<h2>${filename_no_ext}</h2>
${html_content}
EOF
done

# End of HTML content
cat <<EOF >> "${output_html}"
<hr />
    <footer>
        <small>
            <p>contacto dziafr@gmail.com</p>
            <p>actualizado $(date "+%d/%m/%y")</p>
        </small>
    </footer>
</body>
</html>
EOF

echo "index.html successfully created."
