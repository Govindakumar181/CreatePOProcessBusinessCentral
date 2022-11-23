table 70303 SampleDataTable
{
    DataClassification = ToBeClassified;
    Caption = 'Sample Page';
    DataPerCompany = true;
    DataCaptionFields = CodeID;

    fields
    {
        field(1; CodeID; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code ID';
            NotBlank = true;
        }
        field(2; Description; Text[60])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

    }

    keys
    {
        key(PK; CodeID)
        {
            Clustered = true;
        }
    }

}
