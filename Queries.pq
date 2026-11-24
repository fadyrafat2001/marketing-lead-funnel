// UNEXECUTED M SOURCE. Create text parameter WorkbookPath with the full local path of Synthetic_Inputs.xlsx.
// Create this function as fxSheet; every query below is a separate query, not one script.
(sheetName as text) as table =>
let
    Source = Excel.Workbook(File.Contents(WorkbookPath), null, true),
    Data = Source{[Item=sheetName, Kind="Sheet"]}[Data],
    Headers = Table.PromoteHeaders(Data, [PromoteAllScalars=true])
in
    Headers

// Query named DimCampaign:
let
    Source = fxSheet("DimCampaign"),
    Typed = Table.TransformColumnTypes(Source, {{"CampaignKey", Int64.Type}, {"CampaignName", type text}, {"Channel", type text}}, "en-US")
in
    Typed

// Query named DimRegion:
let
    Source = fxSheet("DimRegion"),
    Typed = Table.TransformColumnTypes(Source, {{"RegionKey", Int64.Type}, {"Region", type text}, {"Country", type text}}, "en-US")
in
    Typed

// Query named DimDate:
let
    Source = fxSheet("DimDate"),
    Typed = Table.TransformColumnTypes(Source, {{"Date", type date}, {"Year", Int64.Type}, {"MonthNum", Int64.Type}, {"MonthName", type text}, {"YearMonth", type text}}, "en-US")
in
    Typed

// Query named FactLeads (raw sheet has 5 won leads flagged unqualified and 4 close dates before the created date):
let
    Source = fxSheet("FactLeads"),
    Typed = Table.TransformColumnTypes(Source, {{"LeadID", type text}, {"CreatedDate", type date}, {"CampaignKey", Int64.Type}, {"RegionKey", Int64.Type}, {"LeadScore", Int64.Type}, {"IsQualified", Int64.Type}, {"IsWon", Int64.Type}, {"ClosedDate", type date}, {"DealValue", type number}}, "en-US"),
    QualFix = Table.AddColumn(Typed, "IsQualifiedFix", each if [IsWon] = 1 then 1 else [IsQualified], Int64.Type),
    DropOld = Table.RemoveColumns(QualFix, {"IsQualified"}),
    Renamed = Table.RenameColumns(DropOld, {{"IsQualifiedFix", "IsQualified"}}),
    Days = Table.AddColumn(Renamed, "DaysToClose", each if [IsWon] = 1 and [ClosedDate] <> null and [ClosedDate] >= [CreatedDate] then Duration.Days([ClosedDate] - [CreatedDate]) else null, Int64.Type)
in
    Days
