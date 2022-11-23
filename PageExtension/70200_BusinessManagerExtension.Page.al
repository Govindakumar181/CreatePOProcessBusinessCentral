pageextension 70200 BusinessManagerRoleExt extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Action41)
        {
            group(API)
            {
                Caption = 'API Management';

                action(ActionCreatePO)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create PO From API';

                    RunObject = Page PurchaseOrderDialog;
                }


                action(ExcelPage)
                {
                    ApplicationArea = Suite;
                    Caption = 'Excel Page';

                    RunObject = Page SampleDataPage;
                }

            }
        }
    }
}