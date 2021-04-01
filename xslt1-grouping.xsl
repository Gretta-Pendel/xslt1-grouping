<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" version="1.2" />

  <!-- Get all links -->
  <xsl:variable name="Urls" select="root/descendant::a" ></xsl:variable>

  <!-- Root domains: -->
  <xsl:variable name="hosts">
    <xsl:call-template name="get_hosts">
      <xsl:with-param name="urls" select="$Urls"></xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="uniqueHosts">
    <xsl:call-template name="get_unique_hosts">
      <xsl:with-param name="hosts" select="$hosts"></xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:template match="a">
    <p><b><xsl:value-of select="."/></b>: <xsl:value-of select="@href"/></p>
  </xsl:template>

  <xsl:template match="/">    
    <!-- Print all root domains: -->
    <xsl:value-of select="$hosts"/>
    <xsl:text>&#xA;</xsl:text><!-- new line -->
    <!-- Print all unique root domains: -->
    <xsl:value-of select="$uniqueHosts"/>
    <xsl:text>&#xA;</xsl:text><!-- new line -->
    <!-- Print links: -->
    <xsl:apply-templates select="$Urls"></xsl:apply-templates>
    
  </xsl:template> 
  
  <!-- Get root domains from urls: -->
  <xsl:template name="get_hosts">
    <xsl:param name="urls"></xsl:param>
     <xsl:for-each select="$urls/@href">
        <xsl:sort select="substring-before(substring-after(., '//'),'/')"></xsl:sort>
        <xsl:variable name="url">
          <!-- Trim third-level domains and subdomains: -->
          <xsl:call-template name="trimmer">
            <xsl:with-param name="str" select="substring-before(substring-after(., '//'),'/')">
            </xsl:with-param>
          </xsl:call-template>
        </xsl:variable>  

        <xsl:value-of select="$url" ></xsl:value-of><xsl:text>|</xsl:text>

      </xsl:for-each>
  </xsl:template>

<!-- Get unique root domains from urls: -->
  <xsl:template name="get_unique_hosts">
    <xsl:param name="hosts"></xsl:param> <!-- all root domains -->

    <xsl:variable name="host_before_string">
          <xsl:value-of select="substring-before($hosts, '|')"></xsl:value-of> <!-- first root domain -->
      </xsl:variable>
      <xsl:variable name="host_after_string">
          <xsl:value-of select="substring-after($hosts, '|')"></xsl:value-of> <!-- other root domain -->
      </xsl:variable>    

      <xsl:if test="not(contains($host_after_string, $host_before_string))">
        <!-- the rest of the set does not have the first root domain -->
        <!-- get first root domain -->        
        <xsl:value-of select="$host_before_string"></xsl:value-of><xsl:text>|</xsl:text>
      </xsl:if>
      <!-- more -->

      <xsl:choose>

        <xsl:when test="string-length($host_after_string) > 0">
            <!-- if there are still root domains in the set => RECURSION -->
            <xsl:call-template name="get_unique_hosts">
                <xsl:with-param name="hosts" select="$host_after_string"></xsl:with-param>
            </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
        </xsl:otherwise>

      </xsl:choose> 

  </xsl:template>
      
  <!-- Trim all domains except the root: -->
  <xsl:template name="trimmer">
    <xsl:param name="str"></xsl:param>

    <xsl:choose>
      <xsl:when test="contains(substring-after($str,'.'),'.')">
        <xsl:call-template name="trimmer">
            <xsl:with-param name="str" select="substring-after($str,'.')"></xsl:with-param>
          </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
</xsl:stylesheet>