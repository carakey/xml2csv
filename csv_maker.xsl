<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.loc.gov/mods/v3">
    
    <xsl:output method="text"/>
    
    <xsl:param name="fieldList" select="document('headers_test.xml')"/>
        
    <xsl:template match="/">
        <xsl:call-template name="headerRow"/>
        <xsl:apply-templates select="modsCollection/mods"/>
    </xsl:template>
    
    <!-- Begin header row -->
    <xsl:template name="headerRow">
        <xsl:for-each select="$fieldList//field">
            <xsl:value-of select="header"/>
            <xsl:choose>
                <xsl:when test="position()!=last()">
                    <xsl:text>,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <!-- End header row -->
  
    <xsl:template match="mods">
        <xsl:variable name="record" select="."/>
        <xsl:for-each select="$fieldList//field">
            <xsl:variable name="header" select="header"/>
            <xsl:variable name="value">
                <xsl:choose>
                    <xsl:when test="contains($header,'roleTerm')">
                        <xsl:value-of select="$record/roleTerm"/>
                    </xsl:when>
                    <xsl:when test="not(contains(./path,'displayLabel'))">
                        <xsl:value-of select="normalize-space($record/*[name()=$header])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space($record/*[@displayLabel=$header]//text())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$value"/>
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>