page 70304 SampleDataPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SampleDataTable;
    Caption = 'Sample Data Page';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(CodeID; Rec.CodeID)
                {
                    ApplicationArea = All;
                    Caption = 'Code ID';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(ImportData)
            {
                Caption = 'Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Import Data from Excel';

                trigger OnAction()
                var

                begin
                    // if Rec.CodeID = '' then
                    //     Error(SampleDataIDISBlankMsg);
                    ReadExcelSheet();
                    ImportExcelData();
                end;

            }
        }
    }

    var
        CodeID: Code[50];
        FileName: Text[100];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        SampleDataIDISBlankMsg: Label 'Code ID is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';


    local procedure ReadExcelSheet()
    var

        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin

        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        sampleDataTable: Record SampleDataTable;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Code[50];
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        sampleDataTable.Reset();
        if sampleDataTable.FindLast() then
            LineNo := sampleDataTable.CodeID;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            sampleDataTable.Init();
            Evaluate(sampleDataTable.CodeID, GetValueAtCell(RowNo, 1));
            Evaluate(sampleDataTable.Description, GetValueAtCell(RowNo, 2));
            sampleDataTable.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}
