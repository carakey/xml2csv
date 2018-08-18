<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <!--    
        This stylesheet reads a source XML file and outputs an arbitrary XML file 
        listing each XPath in the source as a string.
        In the resulting document, the distinct-values() function may be used to
        identify unique XPaths.
        
        Note that these strings cannot be substituted for expressions in follow-on XSL
        1.0 or 2.0 stylesheets.
    -->

    <xsl:output method="xml" indent="yes"/>

    <!--  Creates the root xpathList element; creates an xpath element for each terminal "leaf" element -->
    <xsl:template match="/">
        <xpathList>
            <xsl:for-each select="//*[not(child::*)]">
                <xpath>
                    <xsl:text>/</xsl:text>
                    <xsl:apply-templates select="."/>
                </xpath>
            </xsl:for-each>
        </xpathList>
    </xsl:template>

    <!-- Builds xpath string by recursively applying following templates to parent elements; adds '/' delimiters. -->
    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="parent::*">
                <xsl:apply-templates select="parent::*"/>
                <xsl:text>/</xsl:text>
                <xsl:call-template name="element"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="element"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Adds the current element name to the xpath string; checks for attributes on the current element. -->
    <xsl:template name="element">
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*"/>
    </xsl:template>

    <!-- Adds the current attribute name with attribute syntax to the xpath string; omits @schemaLocation. -->
    <xsl:template match="@*">
        <xsl:if test="not(contains(name(), 'schemaLocation'))">
            <xsl:value-of select="(concat('[@', name(), '=&quot;', ., '&quot;]'))"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>