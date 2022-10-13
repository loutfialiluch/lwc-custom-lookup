/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, api } from "lwc";
import searchRecords from "@salesforce/apex/CustomLookupController.searchRecords";

const TIMEOUT_DELAY = 250;

export default class CustomLookup extends LightningElement {
  @api index;
  @api objectApiName = "Account";
  @api searchFields = "Name, AccountNumber";
  @api iconName = "standard:account";
  @api labelName = "Account";
  @api labelHidden = false;
  @api placeholder = "Search for an account";
  @api fieldsToDisplay = "Name, AccountNumber";
  @api filter;

  searchTimeoutId;
  returnedRecords;
  selectedRecord;
  objectLabel;
  iconUrl;

  connectedCallback() {
    const [iconType, iconName] = this.iconName.split(":");
    this.iconUrl = `/apexpages/slds/latest/assets/icons/${iconType}-sprite/svg/symbols.svg#${iconName}`;
    this.setObjectLabel();

    // When a user clicks outside the custom lookup, we empty the list and the selection list gets closed
    window.addEventListener("click", () => (this.returnedRecords = null));
  }

  get isReturnedRecordsEmpty() {
    return this.returnedRecords && !this.returnedRecords.length;
  }

  handleInputChange(event) {
    const { value: searchKey } = event.target;
    this.searchRecords(searchKey);
  }

  handleFocus(event) {
    const { value: searchKey } = event.target;
    this.searchRecords(searchKey);
  }

  handleSelect(event) {
    const { recordId: selectedRecordId } = event.currentTarget.dataset;

    this.selectedRecord = this.returnedRecords.find(({ Id }) => {
      return Id === selectedRecordId;
    });

    const selectedRecordEvent = new CustomEvent("lookup", {
      detail: {
        index: this.index,
        selectedRecordId
      }
    });
    this.dispatchEvent(selectedRecordEvent);
  }

  handleClose() {
    this.selectedRecord = null;
    this.returnedRecords = null;
    const selectedRecordEvent = new CustomEvent("lookup", {
      detail: {
        index: this.index,
        selectedRecordId: null
      }
    });
    this.dispatchEvent(selectedRecordEvent);
  }

  //  ************* HELPERS *************
  setObjectLabel() {
    if (this.objectApiName.includes("__c")) {
      this.objectLabel = this.objectApiName.replace("__c", "");
      this.objectLabel = this.objectLabel.replaceAll("_", " ");
    } else {
      this.objectLabel = this.objectApiName;
    }
    this.objectLabel = this.toTitleCase(this.objectLabel);
  }

  toTitleCase(string) {
    let splittedString = string.toLowerCase().split(" ");
    for (let i = 0; i < splittedString.length; i++) {
      splittedString[i] = splittedString[i][0].toUpperCase() + splittedString[i].substr(1);
    }
    return splittedString.join(" ");
  }

  searchRecords(searchKey) {
    searchKey = searchKey.trim();
    window.clearTimeout(this.searchTimeoutId);
    const fieldsToDisplay = this.fieldsToDisplay.split(",");
    if (!searchKey) {
      this.returnedRecords = null;
      return;
    }
    if (searchKey.length >= 2) {
      this.searchTimeoutId = setTimeout(() => {
        searchRecords({
          objectApiName: this.objectApiName,
          searchFields: this.searchFields.split(","),
          searchKey,
          fieldsToQuery: fieldsToDisplay,
          filter: this.filter
        })
          .then((response) => {
            this.returnedRecords = response.map((record) => ({
              Id: record.Id,
              fieldOne: record[fieldsToDisplay[0]] || null,
              fieldTwo: record[fieldsToDisplay[1]] || null,
              fieldThree: record[fieldsToDisplay[2]] || null
            }));
          })
          .catch((error) => {
            console.error(error);
          });
      }, TIMEOUT_DELAY);
    }
  }
  //  ************* /HELPERS *************
}