/// <reference types="cypress" />
// @ts-check

import * as loginData from '../../fixtures/testData/loginData.json';
import * as updatePassword from '../../fixtures/testData/updatePassword.json'

let authToken: string;
context('Login mandatory fields missing', () => {

    Object.keys(loginData.userValidLogin).forEach((key: string) => {
        let updatedValue: any = {}
        updatedValue[key] = null;

        let user = Object.assign({}, loginData.userValidLogin, updatedValue)

        it(`has missing parameter ${key}`, () => {
            cy.signin(user)
                .then((response) => {
                    expect(response.status).equal(400)
                    expect(response.body.error).does.not.contain("Internal Server Error")


                });
        })
    });
});

context('ePass Login Test Cases', () => {
    it('Login as requester with Approved email', () => {
        let user = loginData.userValidLogin
        cy.signin(user)
            .then((response) => {
                cy.writeFile("cypress/fixtures/testData/login.json", response.body)
                expect(response.status).equal(200)
                authToken=response.body.authToken
                expect(response.body.organizationName).equal('KDS Limited');
                expect(response.body).to.have.all.keys("authToken", "accountID", "accountName", "organizationID", "organizationName")

            })
    })

    it('Login as requester with Rejected email', () => {
        let user = loginData.rejectedUser
        cy.signin(user)
            .then((response) => {
                expect(response.status).equal(400)
                expect(response.body.message).to.have.string('Account declined or blocked')
            })
    })

    it('Login as approver ', () => {
        let user = loginData.approver
        cy.signin(user)
            .then((response) => {
                expect(response.status).equal(200)
                expect(response.body.accountName).to.have.string('superuser')
            })
    })

    it('Update Password', () => {
        let user = updatePassword.valid
        user.authToken=authToken
        cy.updatePassword(user)
            .then((response) => {
                expect(response.status).equal(200)
                expect(response.body).to.have.string('DONE')
            })
    })
})
