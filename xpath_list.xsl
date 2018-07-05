<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.loc.gov/mods/v3">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <root>
            <xsl:for-each select="//*[not(child::*)]">
                <path>
                    <xsl:apply-templates select="."/>
                </path>
            </xsl:for-each>
        </root>
    </xsl:template>

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

    <xsl:template name="element">
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*"/>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:if test="name()[not(.='timestamp')][not(.='source')]">
        <xsl:value-of select="(concat('[@', name(), '=&apos;', ., '&apos;]'))"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>