<!-- testrail2xray.xsl: convert TestRail XML export to XRay CSV import format -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="text" indent="no"/>

  <xsl:template name="DetailRecord">
    <xsl:param name="IssueID"               >0</xsl:param>
    <xsl:param name="IssueKey"              ></xsl:param>
    <xsl:param name="TestType"              >Manual</xsl:param>
    <xsl:param name="TestSummary"           ></xsl:param>
    <xsl:param name="TestPriority"          >Low</xsl:param>
    <xsl:param name="Action"                ></xsl:param>
    <xsl:param name="Data"                  ></xsl:param>
    <xsl:param name="Result"                ></xsl:param>
    <xsl:param name="TestRepo"              ></xsl:param>
    <xsl:param name="Precondition"          ></xsl:param>
    <xsl:param name="IssueType"             ></xsl:param>
    <xsl:param name="PreconditionType"      ></xsl:param>
    <xsl:param name="UnstructuredDefinition"></xsl:param>
    <xsl:param name="Labels"                ></xsl:param>

    <!-- Use a non-zero IssueID if given (e.g. a PreconditionID), otherwise         -->
    <!-- auto-increment it from one (once, from the root element, normally "suite") -->
    <xsl:choose>
      <xsl:when test="$IssueID = 0"><xsl:number level="any" from="suite|/"/></xsl:when>
      <xsl:when test="$IssueID > 0"><xsl:value-of select="$IssueID"       /></xsl:when>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$IssueKey"              /><xsl:text>,</xsl:text>
    <xsl:choose>
      <xsl:when test="normalize-space($TestType) = 'Manual'"     ><xsl:value-of select="$TestType"/></xsl:when>
      <xsl:when test="normalize-space($TestType) = 'Exploratory'"><xsl:value-of select="$TestType"/></xsl:when>
      <xsl:when test="normalize-space($TestType) = 'Automated'"  >Generic</xsl:when>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$TestSummary"           /><xsl:text>,</xsl:text>
    <xsl:choose>
      <xsl:when test="normalize-space($TestPriority) = 'Critical'">1</xsl:when>
      <xsl:when test="normalize-space($TestPriority) = 'High'"    >2</xsl:when>
      <xsl:when test="normalize-space($TestPriority) = 'Medium'"  >3</xsl:when>
      <xsl:when test="normalize-space($TestPriority) = 'Low'"     >4</xsl:when>
      <xsl:otherwise                                              >3</xsl:otherwise>
    </xsl:choose>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$Action"                /><xsl:text>,</xsl:text>
    <xsl:value-of select="$Data"                  /><xsl:text>,</xsl:text>
    <xsl:value-of select="$Result"                /><xsl:text>,</xsl:text>
    <xsl:value-of select="$TestRepo"              /><xsl:text>,</xsl:text>
    <xsl:value-of select="$Precondition"          /><xsl:text>,</xsl:text>
    <xsl:value-of select="$IssueType"             /><xsl:text>,</xsl:text>
    <xsl:value-of select="$PreconditionType"      /><xsl:text>,</xsl:text>
    <xsl:value-of select="$UnstructuredDefinition"/><xsl:text>,</xsl:text>
    <xsl:value-of select="$Labels"                /><xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="suite">
    <xsl:text>Issue ID,</xsl:text>
    <xsl:text>Issue Key,</xsl:text>
    <xsl:text>Test Type,</xsl:text>
    <xsl:text>Test Summary,</xsl:text>
    <xsl:text>Test Priority,</xsl:text>
    <xsl:text>Action,</xsl:text>
    <xsl:text>Data,</xsl:text>
    <xsl:text>Result,</xsl:text>
    <xsl:text>Test Repo,</xsl:text>
    <xsl:text>Precondition,</xsl:text>
    <xsl:text>Issue Type,</xsl:text>
    <xsl:text>Precondition Type,</xsl:text>
    <xsl:text>Unstructured Definition,</xsl:text>
    <xsl:text>Labels</xsl:text>
    <xsl:text>
</xsl:text>

    <xsl:template match="suite//section">
      <xsl:template match="cases/case">

        <xsl:template match="custom">
          <xsl:template match="preconds">
            <xsl:call-template name="DetailRecord">
              <xsl:with-param name="TestSummary"      select="preconds"/>
              <xsl:with-param name="IssueType"        select="'precondition'"/>
              <xsl:with-param name="PreconditionType" select="'Manual'"/>
            </xsl:call-template>
          </xsl:template>

          <xsl:template match="steps">
            <xsl:call-template name="DetailRecord">
              <xsl:with-param name="TestType"     select="../automation_type/value"/>
              <xsl:with-param name="TestSummary"  select="../../title"/>
              <xsl:with-param name="TestPriority" select="../../priority"/>
              <xsl:with-param name="Action"       select="."/>
              <xsl:with-param name="Result"       select="../expected"/>
              <xsl:with-param name="TestRepo"     select="../../name"/>
              <xsl:with-param name="Precondition" select=""/>
              <xsl:with-param name="Labels"       select="../../type"/>
            </xsl:call-template>
          </xsl:template>

          <xsl:template match="steps_separated">
            <xsl:for-each select="step">
              <xsl:if test="position() = 1">
                <xsl:call-template name="DetailRecord">
                  <xsl:with-param name="TestType"     select="../../automation_type/value"/>
                  <xsl:with-param name="TestSummary"  select="../../../title"/>
                  <xsl:with-param name="TestPriority" select="../../../priority"/>
                  <xsl:with-param name="Action"       select="content"/>
                  <xsl:with-param name="Data"         select="additional_info"/>
                  <xsl:with-param name="Result"       select="expected"/>
                  <xsl:with-param name="TestRepo"     select="../../../name"/>
                  <xsl:with-param name="Precondition" select=""/>
                  <xsl:with-param name="Labels"       select="../../../type"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="position() > 1">
                <xsl:call-template name="DetailRecord">
                  <xsl:with-param name="TestType"     select="../../automation_type/value"/>
                  <xsl:with-param name="Action"       select="content"/>
                  <xsl:with-param name="Data"         select="additional_info"/>
                  <xsl:with-param name="Result"       select="expected"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:for-each>
            <xsl:if test="not(step)">
              <xsl:call-template name="DetailRecord">
                <xsl:with-param name="TestType"     select="../automation_type/value"/>
                <xsl:with-param name="TestSummary"  select="../../title"/>
                <xsl:with-param name="TestPriority" select="../../priority"/>
                <xsl:with-param name="TestRepo"     select="../../name"/>
                <xsl:with-param name="Precondition" select=""/>
              </xsl:call-template>
            </xsl:if>
          </xsl:template>

          <xsl:template match="goals|mission">
            <xsl:call-template name="DetailRecord">
              <xsl:with-param name="TestType"     select="'Exploratory'"/>
              <xsl:with-param name="TestSummary"  select="../../title"/>
              <xsl:with-param name="TestPriority" select="../../priority"/>
              <xsl:with-param name="TestRepo"     select="../../name"/>
              <xsl:with-param name="Precondition" select=""/>
              <xsl:choose>
                <xsl:when test="../mission and ../goals">
                  <xsl:with-param
                    name="UnstructuredDefinition"
                    select="concat('*Mission:* ', ../mission, ' *Goals:* ', ../goals)">
                  </xsl:with-param>
                </xsl:when>
                <xsl:when test="../mission">
                  <xsl:with-param name="UnstructuredDefinition" select="concat('*Mission:* ', ../mission)"/>
                </xsl:when>
                <xsl:when test="../goals">
                  <xsl:with-param name="UnstructuredDefinition" select="concat('*Goals:* ', ../goals)"/>
                </xsl:when>
              </xsl:choose>
              <xsl:with-param name="Labels" select="type"/>
            </xsl:call-template>
          </xsl:template>
        </xsl:template>

        <xsl:if test="not(custom)">
          <xsl:call-template name="DetailRecord">
            <xsl:with-param name="TestType"     select="../../type"/>
            <xsl:with-param name="TestSummary"  select="../../title"/>
            <xsl:with-param name="TestPriority" select="../../priority"/>
            <xsl:with-param name="TestRepo"     select="../../name"/>
            <xsl:with-param name="Labels"       select="../../type"/>
          </xsl:call-template>
        </xsl:if>

      </xsl:template>
    </xsl:template>
  </xsl:template>
</xsl:stylesheet>
