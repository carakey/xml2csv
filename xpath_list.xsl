<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.loc.gov/mods/v3">
    
    <xsl:output method="text" />
  
    
<!--    <xsl:variable name="topLevelElement" select="modsCollection/mods/*"/>
    <xsl:variable name="attributeName" select="./@*/name()"/>
    
    <xsl:template match="/">
        <xsl:for-each select="$topLevelElement">
            <xsl:value-of select="./name()"/>
            <xsl:text>[@</xsl:text>
            <xsl:for-each select="./@*">
            <xsl:value-of select="$attributeName"/>
            <xsl:text>]</xsl:text>
            </xsl:for-each>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:for-each select="distinct-values(local-name())">
            <xsl:value-of select="."/>
            <xsl:text>&#xa;</xsl:text>    
        </xsl:for-each>
        <xsl:apply-templates select="@*|*"/>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:value-of select="local-name(..)"/>
        <xsl:value-of select="local-name()"/>
    </xsl:template>-->
    
<!--    <xsl:template match="/">
        <xsl:value-of select="distinct-values(//*[not(name()='dmGetItemInfo')]/string-join(
            (name(), @*/concat('[@', name(), '=&quot;', ., '&quot;', ']')), ''))" 
            separator="&#10;"/>
    </xsl:template>-->
    

    
    
 <!--   <xsl:template match="//*">
            <xsl:for-each select="ancestor-or-self::*">
                <xsl:call-template name="print-step"/>
            </xsl:for-each>
        <xsl:apply-templates select="*"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <xsl:template name="print-step">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:for-each select="@*">
            <xsl:value-of select="concat('[@', name(), '=&quot;', ., '&quot;]')"/>
        </xsl:for-each>
    </xsl:template>-->

<xsl:template match="/">
    <xsl:apply-templates select="//*[not(child::*)]"/>
</xsl:template>

    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="parent::*">
                <xsl:value-of select="name()"/>
                <xsl:apply-templates select="@*"/>
                <xsl:text>/</xsl:text>
                <xsl:apply-templates select="parent::*"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="name()"/>
                <xsl:apply-templates select="@*"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:value-of select="(concat('[@', name(), '=&quot;', ., '&quot;]'))"/>
    </xsl:template>
    
</xsl:stylesheet>