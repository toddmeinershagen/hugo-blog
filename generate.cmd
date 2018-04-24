pandoc --standalone -t html5 -c c:\users\todd\desktop\resume\style.css todd-meinershagen.md -o todd-meinershagen.pdf
pandoc --standalone -t html5 -c c:\users\todd\desktop\resume\pandoc.css todd-meinershagen.md -o todd-meinershagen.pdf
pandoc --standalone -t html5 -c c:\users\todd\desktop\resume\pandoc2.css todd-meinershagen.md -o todd-meinershagen.pdf
pandoc --from=markdown --to=html --output=todd-meinershagen.html todd-meinershagen.md
pandoc --from=markdown --to=docx --output=todd-meinershagen.docx todd-meinershagen.md
pandoc --from=markdown --to=plain --output=todd-meinershagen.txt todd-meinershagen.md
wkhtmltopdf todd-meinershagen.html todd-meinershagen.pdf


pandoc -o resume.html -c resume-css-stylesheet.css resume.md
wkhtmltopdf resume.html resume.pdf
pandoc -o resume.docx --reference-doc=resume-docx-reference.docx resume.md

all: index.html index.pdf index.docx index.txt

index.html: index.md style.css
	pandoc --standalone -c style.css --from markdown --to html -o index.html index.md

index.pdf: index.html
	wkhtmltopdf index.html index.pdf

index.docx: index.md
	pandoc --from markdown --to docx -o index.docx index.md

index.txt: index.md
	pandoc --standalone --smart --from markdown --to plain -o index.txt index.md

clean:
rm -f *.html *.pdf *.docx *.txt