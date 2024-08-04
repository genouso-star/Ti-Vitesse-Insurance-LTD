import { LightningElement, api } from 'lwc';
import getVehicles from '@salesforce/apex/AP001_VehiclesCallouts.getVehicles';
import UpdateVehicles from '@salesforce/apex/AP001_VehiclesCallouts.UpdateVehicles';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

// const columns = [
//     { label: 'Registration number', fieldName: 'RegistrationNumber' },
//     { label: 'Make', fieldName: 'Make' },
//     { label: 'Model', fieldName: 'Model' },
//     { label: 'Year of Vehicle', fieldName: 'YearOfVehicle'},
// ];

export default class LWC001_VehicleOnLoan extends LightningElement {
    @api recordId
    show;

    lstvehicle = [];
    connectedCallback() {
        getVehicles().then((res) => {
        this.lstvehicle = res;
        if(this.lstvehicle.length > 0){
            this.show = true;
        } else this.show = false;
        }).catch((error) => {
        console.log('error ', error);
        });
    }

    handleVehicleClick(evt) {
        this.showSuccessToast();
         var vehicle = this.lstvehicle.find(x=>x.RegistrationNumber==evt.target.value);
         console.log('vehicle :::', vehicle);
         UpdateVehicles({ obj: vehicle, idRecordCase: this.recordId }).then((res) => {
         console.log('update ::::' , res);
         if (res == null) {
             this.showErrorToast();
         } else {
             this.showSuccessToast();
             this.dispatchEvent(new CloseActionScreenEvent());
         }
         }).catch((error) => {
         console.log('error ', error);
         });
    }

    showErrorToast() {
         const evt = new ShowToastEvent({
         title: 'Assign Error',
         variant: 'error',
         mode: 'dismissable'
         });
         this.dispatchEvent(evt);
    }
    showSuccessToast() {
         const evt = new ShowToastEvent({
         title: 'Assign Success',
         variant: 'success',
         mode: 'dismissable'
         });
         this.dispatchEvent(evt);
    }
    // @api recordId;
    // @track lstvehicle;
    // lstVehicle;
    // columns = columns;
    // rowOffset = 0;
    // show;

    // lstvehicle = [];
    // async connectedCallback(){
    //     setTimeout(() => {
    //         getVehicleOfClaim({ claimId: this.recordId })
    //             .then((result) => {
    //                 this.lstvehicle = result;
    //                 this.test();
    //             });
    //     }, 500);
    // }

    // async test() {
    //     if(this.lstvehicle.length == 1) {
    //         this.show = false;
    //     } else {
    //         this.show = true;
    //     }
    // }

    // async assign() {
    //     try {
    //         var selectedVehicle = this.template.querySelector("lightning-datatable").getSelectedRows();
    //         console.log('selectedVehicle = ',selectedVehicle);
    //         UpdateVehicles({ Obj: {selectedVehicle}, idRecordCase : this.recordId})
    //         .then((result) => {
    //             this.lstvehicle = result;
    //             console.log('this.lstvehicle = ',this.lstvehicle);
    //         });
    //         this.showSuccessToast();
    //         this.dispatchEvent(new CloseActionScreenEvent());
    //     } catch (error) {
    //         this.showErrorToast();
    //     }
        
    // }

    // async changeVehicle() {
    //     this.showSuccessToast();
    //     // this.show = true;
    //     // this.lstvehicle = await getVehicles();
    // }

    // closeAction() {
    // this.dispatchEvent(new CloseActionScreenEvent());
    // }

    // showErrorToast() {
    //     const evt = new ShowToastEvent({
    //     title: 'Assign Error',
    //     variant: 'error',
    //     mode: 'dismissable'
    // });
    //     this.dispatchEvent(evt);
    // }

    // showSuccessToast() {
    //     const evt = new ShowToastEvent({
    //     title: 'Assign Success',
    //     variant: 'success',
    //     mode: 'dismissable'
    // });
    //     this.dispatchEvent(evt);
    // }
}