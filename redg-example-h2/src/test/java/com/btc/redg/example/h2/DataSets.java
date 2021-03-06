package com.btc.redg.example.h2;

import com.btc.redg.example.h2.helpers.CountryCodeDefaultValueProvider;
import com.btc.redg.example.h2.helpers.CreditCardNumberDefaultValueProvider;
import com.btc.redg.generated.GCreditCard;
import com.btc.redg.generated.RedG;
import com.btc.redg.runtime.AbstractRedG;
import com.btc.redg.runtime.RedGBuilder;
import com.btc.redg.runtime.defaultvalues.DefaultDefaultValueStrategy;
import com.btc.redg.runtime.defaultvalues.DefaultValueStrategyBuilder;
import com.btc.redg.runtime.defaultvalues.pluggable.DefaultDefaultValueProvider;
import com.btc.redg.runtime.defaultvalues.pluggable.IncrementingNumberProvider;
import com.btc.redg.runtime.defaultvalues.pluggable.PluggableDefaultValueStrategy;

import static com.btc.redg.runtime.defaultvalues.pluggable.buildermatchers.Conditions.contains;
import static com.btc.redg.runtime.defaultvalues.pluggable.buildermatchers.Conditions.eq;
import static com.btc.redg.runtime.defaultvalues.pluggable.buildermatchers.Matchers.allOf;
import static com.btc.redg.runtime.defaultvalues.pluggable.buildermatchers.Matchers.columnName;
import static com.btc.redg.runtime.defaultvalues.pluggable.buildermatchers.Matchers.tableName;

public class DataSets {

    public static AbstractRedG getNameTestDataSet() {
        // The data set for a test that checks whether name of customer equals credit card holder.
        // Only customer and a credit card are relevant

        DefaultValueStrategyBuilder builder = new DefaultValueStrategyBuilder();
        builder.whenTableNameMatches("CREDIT_CARD")
                .andColumnNameMatches("CARD_NUMBER")
                .thenUseProvider(new CreditCardNumberDefaultValueProvider());
        builder.whenColumnNameMatches("COUNTRY_CODE")
                .thenUseProvider(new CountryCodeDefaultValueProvider());
        builder.whenColumnNameMatches(".*_ID").thenUseProvider(new IncrementingNumberProvider());
        builder.setFallbackStrategy(new DefaultDefaultValueStrategy());
        RedG redG = new RedGBuilder<RedG>()
                .withDefaultValueStrategy(builder.build())
                .build();

        for (int i = 0; i < 15; i++) {
            String firstName = FIRST_NAMES[(int) (FIRST_NAMES.length * Math.random())];
            String lastName = LAST_NAMES[(int) (LAST_NAMES.length * Math.random())];
            GCreditCard cc = redG.addCreditCard(redG.dummyBankInstitute())
                    .cardHolder(firstName + " " + lastName);
            redG.addCustomer(cc)
                    .firstName(firstName)
                    .lastName(lastName);
        }


        return redG;
    }

    private static final String[] FIRST_NAMES = {"John", "Joe", "Jim", "Ben", "Mary", "Lisa", "Hannah"};
    private static final String[] LAST_NAMES = { "Smith", "Meier", "Johnson", "Williams"};
}
