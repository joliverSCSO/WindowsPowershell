function Get-Article {
    <#
    .Synopsis
    Gets articles from an RSS feed.

    .Description
    The Get-Article function gets articles from RSS feeds.

    .Parameter Feed
    Gets articles only from the specified RSS feeds. The default is all feeds. 
    Enter the name of a feed or a name pattern. Wildcards are permitted.

    .Example
    Get-Article

    .Example
    Get-Article –feed "Windows PowerShell Blog"

    .Example
    Get-Article | sort pubdate | format-table Title, PubDate

    .Example
    # Gets the content of the most recent article
    ((Get-Article | sort pubdate)[-1]).Description

    .Notes
    The Get-Article function is exported by the PSRSS module. For more information, see about_PSRSS_Module.

    The Get-Article function uses the Items property of Microsoft.FeedsManager objects.

    .Link
    about_PSRSS_Module

    .Link
    "Windows RSS Platform" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684701(VS.85).aspx

    .Link
    "Microsoft.FeedsManager Object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684749(VS.85).aspx

    #>
    param(
        $Feed = "*"
    ) 
        
    Get-Feed -feed $Feed | 
        ForEach-Object {
            $_.Items | ForEach-Object { $_ } 
        }
}