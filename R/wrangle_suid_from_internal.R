wrangle_suid_from_internal <- function(suid_from_internal_raw_df) {
    
    df1 <-
        suid_from_internal_raw_df |> 
        janitor::clean_names() |> 
        # Rename variables for consistency
        rename(
            suid_count = count_asphyxia,
            foreign_born = pe_foreignborn,
            married_males = pe_marriedmales,
            married_females = pe_marriedfemales,
            divorced_widowed_males = pedivorcewidowedmale,
            divorced_widowed_females = pedivorcewidowedfemale,
            lt_high_school = pelessthanhighschool,
            high_school_diploma = highschooldiploma,
            some_college = somecollege,
            college_diploma = collegediploma,
            employed = percent_enployed,
            income_lt_10 = incomelt10,
            income_lt_25 = incomelt25,
            income_lt_50 = incomelt50,
            income_lt_75 = incomelt75,
            income_gt_75 = incomegt75,
            private_insurance = privateinsurance,
            public_insurance = publicinsurance,
            no_insurance = noinsurance
        ) |> 
        mutate(
            # Round all percentage variables to have the same number of trailing decimals
            across(
                .cols = starts_with("svi_"),
                .fns = ~ round((.x * 100), digits = 1)
            ),
            # Binary variable on whether SUID is present in a tract
            suid_present = 
                case_when(
                    suid_count > 0 ~ TRUE,
                    TRUE ~ FALSE
                ),
            # Create an ordered factor version of SUID count
            suid_count_factor = 
                factor(
                    case_when(
                        suid_count == 0 ~ "No Deaths",
                        suid_count == 1 ~ "One Death",
                        suid_count == 2 ~ "Two Deaths",
                        suid_count == 3 ~ "Three Deaths",
                        suid_count == 4 ~ "Four Deaths",
                        suid_count == 5 ~ "Five Deaths",
                        suid_count > 5 ~ "Six+ Deaths"
                    ),
                    ordered = TRUE,
                    levels = c(
                        "No Deaths", 
                        "One Death", 
                        "Two Deaths", 
                        "Three Deaths", 
                        "Four Deaths", 
                        "Five Deaths", 
                        "Six+ Deaths"
                    )
                ),
            .after = suid_count
        )
    
    return(df1)
    
}