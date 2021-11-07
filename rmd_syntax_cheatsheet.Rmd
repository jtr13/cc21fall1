# Common R markdown syntax cheatsheet

Yufan Cao and Yingfei Zhu

R Markdown is a file format for making dynamic documents with R. It provides an authoring frame work of data science. The R Markdown has two main purpose: 
1. Save and execute code
2. Generate high quality reports that can be shared with audience

R Markdown documents can support various of dynamic and static output format, such as pdf or Html. The syntax of R Markdown is also important, students need to learn how to write Markdown syntax to produce a concise and clear reports. 

## Markdown Syntax

### Workflow

- 1. Open a new.Rmd file in the RStudio IED by goting to File > New File > R Markdown

- 2. Embed code in chunks, run code by line, by chunk, or all at once.

- 3. Write text and add tables, images, figures, and citations. Format with Markdown syntax of the RStudio Visual Markdown Editor.

- 4. Set Output format(s) and options in the YAML header. Customize themes or add parameters to execute or add interactivity with Shiny.

- 5. Save and render the whole document. Knit periodically to preview your work as you write.

- 6. Present or share your work. 


### Inline Formatting

- 1. _Italic_ inline text: surrounded by underscores or asterisks (e.g., `_text_` or `*text*`)

- 2. **Bold** text: produced using a pair of double asterisks or surrounded by two underscores (e.g., `**text**` or `__text_``). 

- 3. Turn text to a subscript: using a pair of tildes (`~`) (e.g., `H~3~PO~4~` renders H~3~PO~4~)

- 4. Turn text to a superscript: using a pair of carets(`^`) (e.g., `Cu^2+^` renders Cu^2^+)

- 5. add line in the text: using two pair of tildes(`~~`), (e.g., `~~text~~` renders ~~text~~)

- 6. hyperlink: use the syntax `[text](link), (e.g., `[link](www.rstudio.com)` renders [link](www.rstudio.com))

- 7. Mark text as `inline code`: use a pair of backticks, (e.g., `` `code` ``), to include n literal backticks, use at least n+1 backticks outside, (e.g., you can use three backticks to preserve two backtick inside: ```` ``` ``code`` ``` ````, which is rendered as ``` ``code`` ``` )

- 8.

` ``` `

`text`

` ``` ` 
will renders 

```
text 
```


- 9. `>block quotes` will render as

>block quotes

- 10.  Equation: `$e^{i \pi} +1 = 0$` renders $e^{i \pi} +1 = 0$

- 11. Equation blocks: `$$E = mc^{2}$$` renders 
$$E = mc^{2}$$
- 12. '- ordered list' renders 

- ordered list

- 13. text size: use number sign `#` to adjust the text size for header, as the `#` increase, the size of header decrease.

(e.g., `# Header` renders

# Header


(e.g., `#### Header` renders

#### Header

- 14. Syntax for images: add an exclamation mark, (e.g., `![alt text or image title](path/to/image)`)

- 15. Footnotes: put inside the square brackets after a caret `^`, (e.g., `^[This is a footnote].`)

- 16. Insert citation: typing [@cite] or @cite

- 17. Plain text: just type text in the chunk.

- 18. Start a new paragraph: End a line with two spaces to start a new paragraph

- 19. make a new line: End with a backslash to make a new line
- 20. special symbol, (e.g., escaped: `\*\_ \\` renders escaped: \*\_ \\)
- 21. endash: (e.g., `endash:--,` renders endash:--; `endash:---,` renders endash:---,)
- 22. List: `- unordered list' renders

- unordered list

- 23. Ordered List: 

| - Item 1
|    - Item 1a
|    - Item 2b
|                renders

- Item 1
  - Item 1a
  - Item 2b
  
- 24. Indent text: use line blocks by starting the line with a vertical bar (|). The line breaks and any leading spaces will be preserved in the output. e.g., 

```\
| R is free software and comes with ABSOLUTELY NO WARRANTY.
|     R is a collaborative project with many contributors.
| You are welcome to redistribute it under certain conditions.
|      Platform: x86_64-apple-darwin17.0 (64-bit)
```

The out put is 

>
| R is free software and comes with ABSOLUTELY NO WARRANTY.
|     R is a collaborative project with many contributors.
| You are welcome to redistribute it under certain conditions.
|      Platform: x86_64-apple-darwin17.0 (64-bit)

- 25. Generate a grey text block: start with ` ```\ ` and end with ` ``` `, write text with in the block, e.g.,

` ```\`

R is a useful software.

` ``` `

The output is 

```\
R is a useful software.
```


### Out put format

- 1. html_document creates .html

- 2. pdf_document* creates .pdf

- 3. word_document creates .docx(Microsoft Word)

- 4. powerpoint_presentation creates .pptx(Microsoft Powerpoint)

- 5. odt_document creates OpenDocument Text

- 6. md_document creates Markdown

- 7. github_document creates Markdown for Github

- 8. ioslides_presentation creates ioslides HTML slides

- 9. slidy_presentation creates Slidy HTML slides

- 10. rtf_document creates Rich Text Format

- 11. beamer_presentation creates Beamer Slides

- 12. Requires LateX, bookdown or other format, use tinytex::install_tinytex()

For the output format names in the YAML metadata of an Rmd file, you need to include the package name if a format is from an extension package, e.g., 

```\
output:tufte::tufte_html
```

If the format is from the Rmarkdown package, you do not need the rmarkdown:: prefix

### Embed Code with knitr

- 4.1 CODE CHUNKS

Surround code chunks with ```` ```{r}``` ```` or use the insert Code Chunk button. Add a chunk label and/or chunk options inside  the curly braces after r. 

```\
`  ```{r chunk-label, include = False}
summary(mtcars)``` ` 
```

- 4.2 SET GLOBAL OPTIONS 

Set options for the entire document in the first chunk.

```\
`  ```{r include = FALSE}
knitr::opts_chunk$set(message = FALSE)``` ` 

```

- 4.3 INLINE CODE

Set `r<code>` into text sections. Code is evaluated at render and results appear as text. 

### Render

Use rmarkdown::render() to render/knit at cmd line. 
Important args:

- 5.1 input- file to render

- 5.2 output_options - list of render options(as in YAML)

- 5.3 output_file/output_dir

- 5.4 params - list of parameters to use

- 5.5 envir - environment to evaluate code chunks in 

- 5.6 encoding - of input file


### CHUNK OPTIONS

- cache - cache results for future knits(default = FALSE)

- dependson - chunk dependencies for caching(default = NULL)

- echo - Display code in output document(default = TRUE)

- engine - code language used in chunk(default = 'R')

- error - Display error messages in doc(TRUE) or stop render when errors occur(FALSE) (default = FALSE)

- eval - Run code in chunk(default = TRUE)

- cache.path - directory to save cached results in (default = 'cache/')

- child - file(s) to knit and then include (default = NULL)

- collapse - collapse all output into single block (default = FALSE)

- comment - prefix for each line of results (default = '##')

- fig.align -'left','right', or 'center' (default = 'default')

- fig.cap - figure caption as character string (default = NULL)

- fig.height, fig.width - Dimensions of plots in inches

- highlight - highlight source code (default = TRUE)

- include - include chunk in doc after running (default = TRUE)

- message - display code messages in document (default = TRUE)

- results (default = 'markup')
'asis' - passthrough results
'hide' - do not display results
'hold' - put all results below all code

- tidy - tidy code for display (default = FALSE)

- warning - display code warnings in document (default = TRUE)

## Mathematical Expression

### Mathematical notation

In side a text chunk of rmd file, you can use mathematical notation with dollar sign in two different styles.

Inline LaTeX equations can be written if you surround it by a pair of dollar signs using the LaTeX syntax. Example:  `$f(k) = {n \choose k} p^{k} (1-p)^{n-k}$ ` will produce $f(k) = {n \choose k} p^{k} (1-p)^{n-k}$  

Display style math expressions can be written in a pair of double dollar signs. Example  `$$f(k) = {n \choose k} p^{k} (1-p)^{n-k}$$ ` will produce $$f(k) = {n \choose k} p^{k} (1-p)^{n-k}$$  

Notice: there is no space between the $ and your mathematical notation.
You can also use math environments inside `$ $` or `$$ $$`

### Common Mathematical Symbol

**Math Mode Accents**

|Output|Syntax|
|------|------|
|$x^{n}$|```$x^{n}$```|
|$x_{n}$|```$x_{n}$```|
|$\overline{x}$|```$\overline{x}$```|
|$\hat{x}$|```$\hat{x}$```|
|$\tilde{x}$|```$\tilde{x}$```|
|$\acute{x}$|```$\acute{x}$```|
|$\tilde{x}$|```$\vec{x}$```|
|$\dot{x}$|```$\dot{x}$```|

**Binary Relation**

|Output|Syntax|
|------|------|
|$x = y$|```$x = y$```|
|$x < y$|```$x < y$```|
|$x > y$|```$x > y$```|
|$x \approx y$|```$x \approx y$```|
|$x \ne y$|```$x \ne y$```or```$x \neq y$```|
|$x \le y$|```$x \le y$```|
|$x \ge y$|```$x \ge y$```|
|$x \equiv y$|```$x \equiv y$```|
|$x \ll y$|```$x \ll y$```|
|$x \gg y$|```$x \gg y$```|
|$x \doteq y$|```$x \doteq y$```|
|$x \prec y$|```$x \prec y$```|
|$x \succ y$|```$x \succ y$```|
|$x \sim y$|```$x \sim y$```|
|$x \preceq y$|```$x \preceq y$```|
|$x \succeq y$|```$x \succeq y$```|
|$x \simeq y$|```$x \simeq y$```|
|$x \subset y$|```$x \subset y$```|
|$x \in A$|```$x \in A$```|
|$x \notin A$|```$x \notin A$```|
|$A \ni x$|```$x \ni A$```or```$A \owns x$```|
|$x \subset B$|```$x \subset B$```|
|$x \subseteq B$|```$x \subseteq B$```|
|$A \cup B$|```$A \cup B$```|
|$A \cap B$|```$A \cap B$```|
|$A \perp B$|```$A \perp B$```|
|$A \bowtie B$|```$A \bowtie B$```|
|$A \propto B$|```$A \propto B$```|
|$A \mid B$|```$A \mid B$```|
|$A \parallel B$|```$A \parallel B$```|

**Operators / Statistical Expression**

|Output|Syntax|
|------|------|
|$\frac{a}{b}$|```$\frac{a}{b}$```|
|$\frac{\partial f}{\partial x}$|```$\frac{\partial f}{\partial x}$```|
|$\binom{n}{k}$|```$\binom{n}{k}$```|
|$x_{1} + x_{2} + \cdots + x_{n}$|```$x_{1} + x_{2} + \cdots + x_{n}$```|
|$x_{1}, x_{2}, \dots, x_{n}$|```$x_{1}, x_{2}, \dots, x_{n}$```|
|$\mathbf{x} = \langle x_{1}, x_{2}, \dots, x_{n}\rangle$|```$\mathbf{x} = \langle x_{1}, x_{2}, \dots, x_{n}\rangle$```|
|$|A|$|```$|A|$```|
|$X \sim {\sf Binom}(n, \pi)$|```$X \sim {\sf Binom}(n, \pi)$``` (```sf``` for “slide font”)|
|$\mathrm{P}(X \le x) = {\tt pbinom}(x, n, \pi)$|```$\mathrm{P}(X \le x) = {\tt pbinom}(x, n, \pi)$``` (```tt``` for “typewriter type”)|
|$P(A \mid B)$|```$P(A \mid B)$```|
|$\mathrm{P}(A \mid B)$|```$\mathrm{P}(A \mid B)$``` (```mathrm``` for “math roman font”|
|$\{1, 2, 3\}$|```$\{1, 2, 3\}$```|
|$\sin(x)$|```$\sin(x)$```|
|$\log(x)$|```$\log(x)$```|
|$\int_{a}^{b}$|```$\int_{a}^{b}$```|
|$\left(\int_{a}^{b} f(x) \; dx\right)$|```$\left(\int_{a}^{b} f(x) \; dx\right)$```|
|$\left[\int_{-\infty}^{\infty} f(x) \; dx\right]$|```$\left[\int_{-\infty}^{\infty} f(x) \; dx\right]$```|
|$\left. F(x) \right|_{a}^{b}$|```$\left. F(x) \right|_{a}^{b}$```|
|$\sum_{x = a}^{b} f(x)$|```$\sum_{x = a}^{b} f(x)$```|
|$\prod_{x = a}^{b} f(x)$|```$\prod_{x = a}^{b} f(x)$```|
|$\lim_{x \to \infty} f(x)$|```$\lim_{x \to \infty} f(x)$```|
|$\displaystyle \lim_{x \to \infty} f(x)$|```$\displaystyle \lim_{x \to \infty} f(x)$```|

**Other symbols**

|Output|Syntax|
|------|------|
|$\because$|```$\because$```|
|$\therefore$|```$\therefore$```|
|$\forall$|```$\forall$```|
|$\exists$|```$\exists$```|
|$\partial$|```$\partial$```|
|$\emptyset$|```$\emptyset$```|
|$\nabla$|```$\nabla$```|
|$\triangle$|```$\triangle$```|
|$\angle$|```$\angle$```|
|$\surd$|```$\surd$```|
|$\S$|```$\S$```|
|$\varpropto$|```$\varpropto$```|
|$\diamondsuit$|```$\diamondsuit$```|
|$\heartsuit$|```$\heartsuit$```|
|$\clubsuit$|```$\clubsuit$```|
|$\spadesuit$|```$\spadesuit$```|

### Matrix

- **Matrix with no bracket**

```\
$$X = \begin{array}{ccc}
x_{11} & x_{12} & x_{13}\\
x_{21} & x_{22} & x_{23}
\end{array}$$  
```

$$X = \begin{array}{ccc}
x_{11} & x_{12} & x_{13}\\
x_{21} & x_{22} & x_{23}
\end{array}$$

- **With square bracket**
```\
$$X = \begin{bmatrix}
x_{11} & x_{12} & x_{13}\\
x_{21} & x_{22} & x_{23}
\end{bmatrix}$$
```
$$X = \begin{bmatrix}
x_{11} & x_{12} & x_{13}\\
x_{21} & x_{22} & x_{23}
\end{bmatrix}$$

- **With parentheses**
```\
$$X = \begin{pmatrix}
x_{11} & x_{12} & x_{13}\\
x_{21} & x_{22} & x_{23}
\end{pmatrix}$$
```
$$X = \begin{pmatrix}
x_{11} & x_{12} & x_{13}\\
x_{21} & x_{22} & x_{23}
\end{pmatrix}$$

- **With determinant / vertical bar bracket**
```\
$$\begin{vmatrix} 
   a_{11} & a_{12} & a_{13}  \\
   a_{21} & a_{22} & a_{23}  \\
   \end{vmatrix} $$
```
$$\begin{vmatrix} 
   a_{11} & a_{12} & a_{13}  \\
   a_{21} & a_{22} & a_{23}  \\
   \end{vmatrix}$$
   
- **With curly brackets**
```\
$$\begin{Bmatrix} 
   a_{11} & a_{12} & a_{13}  \\
   a_{21} & a_{22} & a_{23}  \\
   \end{Bmatrix} $$
```
$$\begin{Bmatrix} 
   a_{11} & a_{12} & a_{13}  \\
   a_{21} & a_{22} & a_{23}  \\
   \end{Bmatrix} $$

- **With double vertical bar brackets**
```\
$$\begin{Vmatrix} 
   a_{11} & a_{12} & a_{13}  \\
   a_{21} & a_{22} & a_{23}  \\
   \end{Vmatrix} $$
```
$$\begin{Vmatrix} 
   a_{11} & a_{12} & a_{13}  \\
   a_{21} & a_{22} & a_{23}  \\
   \end{Vmatrix} $$

- **Small inline matrix**

Small inline matrix```$\big(\begin{smallmatrix} a & b\\ c & d \end{smallmatrix}\big)$```  will produce  
Small inline matrix$\big(\begin{smallmatrix} a & b\\ c & d \end{smallmatrix}\big)$

### Greek letters

|Output|Syntax|
|------|------|
|$\alpha A$|```$\alpha A$```|
|$\beta B$|```$\beta B$```|
|$\gamma \Gamma$|```$\gamma \Gamma$```|
|$\delta \Delta$|```$\delta \Delta$```|
|$\epsilon \varepsilon E$|```$\epsilon \varepsilon E$```|
|$\zeta Z \sigma \,\!$|```$\zeta Z \sigma \,\!$```|
|$\eta H$|```$\eta H$```|
|$\theta \vartheta \Theta$|```$\theta \vartheta \Theta$```|
|$\iota I$|```$\iota I$```|
|$\kappa K$|```$\kappa K$```|
|$\lambda \Lambda$|```$\lambda \Lambda$```|
|$\mu M$|```$\mu M$```|
|$\nu N$|```$\nu N$```|
|$\xi\Xi$|```$\xi\Xi$```|
|$o O$|```$o O$```|
|$\pi \Pi$|```$\pi \Pi$```|
|$\rho\varrho P$|```$\rho\varrho P$```|
|$\sigma \Sigma$|```$\sigma \Sigma$```|
|$\tau T$|```$\tau T$```|
|$\upsilon \Upsilon$|```$\upsilon \Upsilon$```|
|$\phi \varphi \Phi$|```$\phi \varphi \Phi$```|
|$\chi X$|```$\chi X$```|
|$\psi \Psi$|```$\psi \Psi$```|
|$\omega \Omega$|```$\omega \Omega$```|

### Aligning Equations

If you want a sequence of aligned equations (often very useful for demonstrating algebraic manipulation or for plugging values into equations), use ```\begin{align*} ... \end{align*}```. Separate lines with ```\\``` and use ```&``` to mark where things should line up. Note: No dollar signs are needed for mathematical expression in this method.

Example:
```\
$\begin{aligned}
AR(p): Y_i &= c + \epsilon_i + \phi_i Y_{i-1} \dots \\
Y_{i} &= c + \phi_i Y_{i-1} \dots
\end{aligned}$
```

$\begin{aligned}
AR(p): Y_i &= c + \epsilon_i + \phi_i Y_{i-1} \dots \\
Y_{i} &= c + \phi_i Y_{i-1} \dots
\end{aligned}$


## Reference
Latex math symbols. Kapeli. (n.d.). Retrieved October 28, 2021, from  
https://kapeli.com/cheat_sheets/LaTeX_Math_Symbols.docset/Contents/Resources/Documents/index.  

Pruim, R. (2016, October 19). Mathematics in R markdown. Retrieved October 28, 2021, from  
https://rpruim.github.io/s341/S19/from-class/MathinRmd.html. 

R markdown : : Cheat sheet - ETH Z. (n.d.). Retrieved October 28, 2021, from   
https://ethz.ch/content/dam/ethz/special-interest/math/statistics/sfs/Education/Advanced%20Studies%20in%20Applied%20Statistics/course-material-1719/Datenanalyse/rmarkdown-2.pdf.

Yihui Xie, C. D. (2021, October 7). R markdown cookbook. 5.2 Indent text. Retrieved October 28, 2021, from   https://bookdown.org/yihui/rmarkdown-cookbook/indent-text.html.

Yihui Xie, J. J. A. (2021, April 9). R markdown: The definitive guide. Home. Retrieved October 28, 2021, from  
https://bookdown.org/yihui/rmarkdown/. 





