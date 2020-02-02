<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:strip-space elements="*"/> <!-- for LaTeX -->
    <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
  
    <xsl:template match="/">

        <xsl:if test="//t:biblStruct">
            <!-- this is the very beginning of the document, even before documentclass! -->
            <xsl:text>\begin{filecontents}{references.bib}
</xsl:text>
            <xsl:for-each select="//t:listBibl/t:biblStruct">
<!-- include XSL choose here to differenciate between different types of bib entries -->
                        <xsl:text>@incollection{</xsl:text><xsl:value-of select="translate(translate(translate(translate(@xml:id, '-_.,;: ',''),'ä','ae'),'ö','oe'),'ü','ue')"/><xsl:text>,
author = {</xsl:text><xsl:value-of select="t:analytic/t:author/t:persName[1]"/><xsl:for-each select="t:analytic/t:author/t:persName[position() > 1]"><xsl:text> and </xsl:text><xsl:value-of select="."/></xsl:for-each><xsl:text>},
title = {</xsl:text><xsl:value-of select="t:analytic/t:title"/><xsl:text>},
editor = {</xsl:text><xsl:value-of select="t:monogr/t:editor/t:persName[1]"/><xsl:for-each select="t:monogr/t:editor/t:persName[position() > 1]"><xsl:text> and </xsl:text><xsl:value-of select="."/></xsl:for-each><xsl:text>},
booktitle = {</xsl:text><xsl:value-of select="t:monogr/t:title"/><xsl:text>},
year = {</xsl:text><xsl:value-of select="t:monogr/t:imprint/t:date"/><xsl:text>},
address = {</xsl:text><xsl:value-of select="t:monogr/t:imprint/t:pubPlace/t:placeName"/><xsl:text>},
pages = {</xsl:text><xsl:value-of select="t:citedRange"/><xsl:text>}
}
</xsl:text>       
                   
            </xsl:for-each>
            
            <xsl:text>\end{filecontents}</xsl:text>
        </xsl:if>

        <xsl:text>
\documentclass[10pt, a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[english,ngerman]{babel}

\usepackage{filecontents}
\usepackage[
backend=biber,
style=alphabetic,
sorting=ynt
]{biblatex}
\addbibresource{references.bib}

\title{</xsl:text><xsl:value-of select="//t:titleStmt/t:title"/><xsl:text>}
\author{</xsl:text><xsl:apply-templates select="//t:teiHeader/t:fileDesc/t:titleStmt/t:author"/>
        <xsl:text>}\date{\today}
\begin{document}
\pagenumbering{arabic}
\maketitle
%\tableofcontents

</xsl:text>
        
<xsl:apply-templates select="//t:body"/>
        <!-- for demonstration purposes, a \footcite was included in the example text
             normally, you would of course need to define templates to achieve this from TEI note elements, etc. -->
        
        
        <!-- end document (with the bibliography settings) -->
        
        <!-- if you want to cite everything in the bib file: -->
        <xsl:text>
            
            \nocite{*}</xsl:text>
        
        <!-- bibliography settings --> 
        
        <xsl:text>\AtNextBibliography{\footnotesize}</xsl:text>
        <xsl:text>
\defbibheading{head}{\section*{Secondary literature}}
\printbibliography[heading=head]
</xsl:text>
        
        <xsl:text>\end{document}</xsl:text>
    </xsl:template>
    
    <xsl:template match="t:head">
        <xsl:text>\section*{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:template>
 
</xsl:stylesheet>