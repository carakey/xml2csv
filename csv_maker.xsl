<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0"
    >
    
    <xsl:output method="text"/>
    
    <xsl:param name="headerFile">
        <!--<xsl:text>sample_data/sample_fields.xml</xsl:text>-->
        <xsl:text>lsu-sc-msw_fields.xml</xsl:text>
    </xsl:param>
    <xsl:variable name="fieldList" select="document($headerFile)"/>
    
    <!-- Sets the field separator with a variable; 
        if necessary, it can be reset throughout -->
    <xsl:variable name="delimiter" select="'&#9;'"/>

    <xsl:template match="/">
        <xsl:call-template name="headerRow"/>
        <xsl:apply-templates select="modsCollection/mods"/>
    </xsl:template>
    
    <!-- to do: 
        * add comments
        * not getting dmGetItemInfo (deliberately, for now, but need to address)
        * subject strings - delimit sibling topics with dashes and separate subjects with semicolons
    -->
    
    <!-- Begin header row -->
    <!-- Uses the fieldNames from the field_list.xsl output as column headers -->
    <xsl:template name="headerRow">
        <xsl:for-each select="$fieldList//field">
            <xsl:value-of select="fieldName"/>
            <!-- Inserts a delimiter after each header until the last, then inserts a new line -->
            <xsl:choose>
                <xsl:when test="position()!=last()">
                    <xsl:value-of select="$delimiter"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <!-- End header row -->
  
    <!-- Begin building record rows -->
    <xsl:template match="mods">
        <!-- Matches each MODS record -->
        <xsl:variable name="record" select="."/>
        <!-- Stores the entire MODS record as a variable -->
        <xsl:for-each select="$fieldList//field">
            <xsl:variable name="header" select="fieldName"/>

            <xsl:variable name="labelMatch">
                <xsl:variable name="labelValue" select="substring-before($header, ' ::')"/>
                <xsl:variable name="terminus" select="replace($header, '^.*:: ', '')"/>
                <xsl:variable name="terminusName" select="substring-before($terminus, ' @')"/>
                <xsl:variable name="attName"
                    select="substring-before(substring-after($terminus, ' @'), '=')"/>
                <xsl:variable name="attValue"
                    select="substring-before(substring-after(substring-after($terminus, $attName), '=&quot;'), '&quot;')"/>
                <xsl:choose>
                    <xsl:when test="contains($header, '::')">
                        <xsl:choose>
                            <xsl:when test="contains($header, '@')">
                                <xsl:for-each
                                    select="$record//*[@displayLabel = $labelValue]//*[name() = $terminusName][@*[name() = $attName] = $attValue]">
                                    <xsl:call-template name="cell"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each
                                    select="$record//*[@displayLabel = $labelValue]//*[name() = $terminus]">
                                    <xsl:call-template name="cell"/>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$record//*[@displayLabel = $header]">
                            <xsl:call-template name="cell"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="elementMatch">
                <xsl:choose>
                    <xsl:when test="contains($header, '@')">
                        <xsl:variable name="elementName" select="substring-before($header, ' @')"/>
                        <xsl:variable name="attName"
                            select="substring-before(substring-after($header, ' @'), '=')"/>
                        <xsl:variable name="attValue"
                            select="substring-before(substring-after(substring-after($header, $attName), '=&quot;'), '&quot;')"/>
                        <xsl:for-each
                            select="$record//*[name() = $elementName][@*[name() = $attName] = $attValue]">
                            <xsl:call-template name="cell"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$record//*[name() = $header]">
                            <xsl:call-template name="cell"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="not(contains(xpath, 'displayLabel'))">
                    <xsl:value-of select="$elementMatch"/>
                </xsl:when>
                <xsl:when test="$labelMatch">
                    <xsl:for-each select="$labelMatch">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:value-of select="$delimiter"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:for-each>
    </xsl:template>

    
    <xsl:template name="cell">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position()!=last()">
            <xsl:text>||</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>