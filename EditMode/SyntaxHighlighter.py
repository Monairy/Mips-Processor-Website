from pygments import highlight
from pygments.lexers import VerilogLexer
from pygments.formatters import HtmlFormatter



with open ('project2.txt','r') as project:
           content=project.read()
           with open ("highlightedproject.txt",'w') as highlighted:
                      highlighted.write(highlight(content, VerilogLexer(), HtmlFormatter(full=True)))
                      print HtmlFormatter().get_style_defs('.highlight')
