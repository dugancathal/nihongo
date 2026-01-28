#ID:~:Kc09FSMW
Upcase bash string var?
---
"${foo^^}"
#ID:~:esuzxDMH
Bashe expansion for substring: {{"${var:3:8}"}}
#ID:~:lyBnUPDG
Bash var expansion to change "Hello World" to "Hellp Wprld" (replace all 'o' with 'p')
---
var="Hello World"
"${var//o/p}"
#ID:~:I0FhbyMH
Bash var expansion to remove "World" from "Hello World"
---
var="Hello World"
"${var%World}"
(Only works on end)
#ID:~:mefSnZbe
What does this evaluate to:

```
echo multi word string
echo !#0
```
---
`echo`
#ID:~:krUGrOiW
Downcase bash string var?
---
"${foo,,}"
#ID:~:vblSQ2lG
Bash var expansion to change "Hello World" to "Hello Bash"
---
var="Hello World"
"${var/World/Bash}"
#ID:~:Je9bctfg
Bash expansion for required or EXIT: {{"${var?:"error message}"}}
#ID:~:xjjho7Yo
What does this evaluate to:

```
echo multi word string
echo !:3 !:0
```
---
`string echo`
#ID:~:C6UxPfQK
Bash prompt response into var `foo`?
---
`read -p "Continue? " foo`