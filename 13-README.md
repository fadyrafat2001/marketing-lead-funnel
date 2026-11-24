# Marketing Lead Funnel

## Business question
Which acquisition channels turn leads into won deals most effectively and fastest, regardless of how many leads they bring in?

## Data and method
All data is synthetic. It is not real company or customer data. The file has 350 leads. Cleaning steps (written in Power Query M in Queries.pq, not yet run in Power BI Desktop; the .pbix embeds the already-cleaned tables):
- Forced IsQualified to 1 for 5 won leads that were flagged unqualified. Qualified leads rise from 135 to 140.
- Set 4 negative close durations (closed before created) to null, leaving 24 valid days-to-close values. The raw ClosedDate stays in the table, and the measure Won Deals With Invalid Dates counts these 4 deals, so they are not hidden. Avg Days to Close averages only the 24 valid ones.
- Used DIVIDE so a campaign with no qualified leads shows blank, not 0%. The Webinar-Pilot campaign has 10 leads and 0 qualified. Podcast Sponsor has no leads.

## Findings
Of 140 qualified leads, 28 were won, a qualified-to-won rate of 20.0% (20.7% before the fix). Paid Search brought 34.3% of leads but 14.3% of wins, with a lead-to-won rate of 3.3% and 42.0 days to close on average. Referral brought 11.4% of leads but 39.3% of wins, with a rate of 27.5% and 20.9 days. Email converted 8.2% in 52.7 days and Webinar 5.0% in 54.7 days.

## Model and measures
Star schema: FactLeads linked many-to-one to DimDate (with a YearMonth column for chart ordering), DimCampaign and DimRegion. Measures: Leads, Qualified Leads, Won Deals, Qualification Rate, Qualified-to-Won Rate, Lead-to-Won Rate, Avg Days to Close, Avg Deal Value, Won Deals With Invalid Dates. The report has two pages: funnel overview, and channel and campaign quality.

## Limits
Small synthetic sample, for illustration only. Channel differences show association, not cause. Channels with few wins (4 each for Paid Search and Webinar) give unstable rates.

## Status
Results were recomputed in Python (pandas) and the DAX was checked with a third-party DAX engine. The generated .pbix file has not yet been opened in Power BI Desktop and still needs to be tested there.

## Provenance
Design (schema, measures, report pages, data rules) was drafted with Claude, then implemented by a separate tool chain. Data generation, the .pbix build and all number checks were done outside Claude. Nothing here is verified by Claude or by Power BI Desktop. Prepared with assistant support, not prior independent work or a real company engagement.
