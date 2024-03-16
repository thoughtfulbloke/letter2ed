Draft Letter
================
David Hood
3/16/24

Things David knows he still needs to do (that don’t alter overall
content):

- more proofreading.

- standard citation format.

- clear links to source data.

- standard figure look

- Captions under graphs.

*The timetable is: I am welcoming changes up to Thursday 21st and
regularly updating the draft here until then. On Thursday 21st I will
make what I expect to be any final changes. On Friday 22nd I will be
distribution the final draft to people who have expressed an interest in
co-signing, with an aim to send it to the journal early in the week
beginning Monday 25th.*

To the editor and editorial board,

I am formally writing to point out the significant errors in the paper
from Gibson (2024)[^1], published in your journal. It is important both
you and your readership are aware of its shortcomings before basing any
decisions on the claims made. In particular, the paper asserts two
claims:

- That claims of negative New Zealand mortality are underpinned by the
  “Our World In Data” projection graph using the method of Karlinsky &
  Kobak[^2].
- That Gibson’s method, producing positive excess mortality, is more
  effective than Karlinsky & Kobak in determining mortality as it
  adjusts for population change due to immigration changes.

Neither of these claims are accurate.

# The underpinning of New Zealand’s mortality measurement

For centuries, it has been established practice among actuaries,
demographers, and health researchers to measure mortality using death
rates by age where such data is available[^3]. This method superseded
Crude Mortality Rates, where CMR takes into account total population
change in comparisons by dividing the total number of deaths by the
total number of people available to die, improving CMR by acknowledging
that different ages have different risks of death, so comparing
age-based risk of death on a uniform basis. In New Zealand, tutorials on
making mortality comparisons by using death rates by age and
standardising to a reference population have been published since the
1890s[^4].

Age Standardised Mortality directly adjusts for both population growth
and aging, as it is based on the number of deaths of the current
resident population divided by the living current resident population,
stratified by age group and time period. This directly measures the
population change effects Gibson is trying to model.

While calculation of New Zealand’s cumulative excess mortality for
2020-2022 can vary by a couple of percentage points depending on the
exact method, using a death rates by age (standardised) method the
Institute of Actuaries finds New Zealand’s excess mortality from week 10
2020 to the end of 2022 to be -4% (that there are 4% fewer deaths than
would be expected based on pre-COVID-19 trends)[^5].

The Our World in Data graph, and the Karlinsky and Kobak method that
underlies it, is an approximation (if it is a better or worse
approximation to Gibson’s method will be discussed later). While
recognising the Our World In Data graph is an approximation, there are
still several practically useful implicit features about it:

- Being based on trends of deaths, it enables a common basis comparison
  with countries that lack age stratified current population information
- It makes weekly comparisons available.
- Able to be checked by any member of the public for the latest current
  worldwide information. This last is a function of Our World in Data
  presentation rather than the method, but it is still a practical
  benefit.

While the existence of centuries of mortality measurement (not mentioned
in Gibson’s article) does not directly address if New Zealand medical
professionals are aware that best practice mortality calculations
recognise that people of different ages die at different rates when
using the publicly available Our World in Data graphs in media pieces,
it does establish that there is an established methodology, not
mentioned in Gibson’s article, underpinning claims of New Zealand’s
negative excess, and that method has been used for centuries,
world-wide, across multiple disciplines. We can check if New Zealand
medical professionals are aware of this by asking them: *“the key point
being any comparisons both within country (over time) or between
countries should be age standardised to provide the most accurate
picture possible (and of course be based on high quality and complete
underlying deaths data which we can say NZ’s are!)”*(Ashley Bloomfield)
[^6].

## Age Standardised Mortality Review

As Age Standardised Mortality is a standard across multiple disciplines,
but is not raised in the Gibson paper, a brief review is in order.

Death rates for an age stratified group, for a time period in a given
location, measure the rate at which that age group dies. These can be
directly compared to death rates in other time periods and locations to
measure if the group experience is more or less deadly. As it is a rate,
it automatically adjusts for change in the population size of the age
group.

While this enables direct comparisons of people of the same age, it does
not enable total population comparisons (as total populations may have
different age structures). Standardisation with a reference population
addresses this by assessing the total population deaths on the basis of
death rates by age if the places and times being compared had the same
age structure.

*Figure 1*

<figure>
<img src="md_figures/figure1.png" data-fig-alt="ASMR process"
data-fig-align="center" alt="ASMR steps" />
<figcaption aria-hidden="true">ASMR steps</figcaption>
</figure>

Some variation in calculation results can be caused by the choice of
standard population, due to the variation of young and old within a
population. However, pragmatically, any population that can be argued to
be analytically useful should produce similar results. Using single year
ages groups by sex to 94 then 95+[^7], and a linear baseline from
2013-2019, a standard reference population of 2023 gives a cumulative
excess of -5% for 2020 to 2022. Using a standard reference population of
2021 when the borders were restricted gives a cumulative excess of -6%.
Using a pre-COVID-19 standard population of 2019 gives a cumulative
excess of -5%. Using the standard population of 1961, used by Stats NZ
to maintain long-term continuity, cumulative excess is -5%.

### Baselines and excess mortality

Excess mortality is the difference to what is expected for mortality, so
excess calculations using any method are sensitive what is considered
normal: the baseline. For Age Standardised Mortality the regular process
is to use a linear trend of preceding years, and in the case of a major
multi-year event like a pandemic, the linear trend of pre-pandemic
years.

As New Zealand, no different to most other advanced economies, has seen
the rate of decrease in mortality slow over time, the length of the
linear trend baseline period should be short enough not to be
introducing error as a result of applying a straight line of best fit to
curved data.

<figure>
<img src="md_figures/figure2.png" data-fig-alt="Overlong baseline error"
data-fig-align="center"
alt="Figure 2: Structural error introduced by overly long baselines. Longterm (age) standardised death rates from https://infoshare.stats.govt.nz in Population : Death Rates - DMM : Standardised death rates (Maori and total population) (Annual-Dec) : Total Population" />
<figcaption aria-hidden="true">Figure 2: Structural error introduced by
overly long baselines. Longterm (age) standardised death rates from
https://infoshare.stats.govt.nz in Population : Death Rates - DMM :
Standardised death rates (Maori and total population) (Annual-Dec) :
Total Population</figcaption>
</figure>

Based on the influenza season patterns in recent pre-pandemic years, the
Australian Bureau of Statistics (ABS) considers 2013-2019 to give the
best baseline[^8]. New Zealand has seen a very similar history in this
period to Australia, with the added limitation that using 2011, the year
of the Christchurch Earthquake and the residents of the second largest
city living in broken housing through the following winter, is an
extremely poor choice to include in baselines as an earthquake hitting
the second largest city and people living in broken housing through the
winter is not a reoccuring annual event.

While many international comparisons use a 5 year baseline range to
increase the number of countries for which weekly level data is
available, in practice the results for New Zealand do not differ
substantively between a 5 (2015-2019) and 7 (2013-2019) year baseline
period. A 5 year linear baseline and a 7 year baseline both give a
cumulative excess for 2020-2022 of -5% when using a 2022 standard
population.

## Comparison of Gibson and Karlinsky & Kobak

Starting from a commonly recognised best practice measure of mortality,
age standised mortality, giving a cumulative excess mortality for
2020-2022 in the range of -4% to -6% depending on analytic assumptions,
we can compare other methods to that.

The Our World in Data cumulative excess (Projection based on Karlinsky &
Kobak) gives cumulative excess mortality for 2020-2022 as 0%.

Gibson’s Population adjusted for changes in growth rates model gives an
excess mortality for 2020-2022 range of 1.7% to 5.3% with the central
estimate rounding to 4%.

Though not mentioned in the paper, adding the Population as a model term
to a death based model would normally be functionally equivalent to
using the commonly known Crude Mortality Rate (deaths among the total
population / total living population). A 2015-2019 linear regression of
the annual CMR gives an excess of 1%.

Gibson’s method produces results further from actuarial standard methods
than the Karlinsky & Kobak method. The reason for Gibson’s model
performing so poorly compared to Karlinsky & Kobak lies in implicitly
misapplying death rates by age. Young people frequently migrate and
infrequently die. Old people infrequently migrate and frequently die.
Applying a correction based on the amount of migration to the mortality
of the total population (dominated by people not migrating) introduces
unnecessary structural error.

<figure>
<img src="md_figures/figure3.png"
data-fig-alt="Young people migrate, old people die"
data-fig-align="center"
alt="Figure 3: Ages of migration and ages of death have little overlap" />
<figcaption aria-hidden="true">Figure 3: Ages of migration and ages of
death have little overlap</figcaption>
</figure>

Conversely, because the Karlinsky & Kobak method only uses death data,
it implicitly limits itself to the population that dies. The population
mainly dying are not migrating, so the model does not diverge as far
from ASM as the Gibson method when border changes cause major
fluctuations in migration.

Gibson asserted that it was not important to incorporate aging:

*If societal aging was a cause of the increased number of deaths, as
Gabel and Knox (2023) put forward as a reason for the excess mortality
in 2022, it should also show up prior to the COVID-19 era, given that
societal aging is a long-term process.*

The assumption that aging is a long term process so should show up as a
long slow process only applies if there are no sudden demographic shifts
among age groups that alter the risk of death. The number of 75 and
older residents, when compared to the 2012-2016 trend, and that trend
can be seen increasing in 2019. This matches a “sudden” demographic
shift of a spike in the age distribution that began decades earlier and
naturally aged into ranges that play a more significant role in total
deaths.

<figure>
<img src="md_figures/figure4.png"
data-fig-alt="Aging increases deaths and the crude death rate"
data-fig-align="center"
alt="Figure 4: The rate of increase in elderly accelerated in 2019" />
<figcaption aria-hidden="true">Figure 4: The rate of increase in elderly
accelerated in 2019</figcaption>
</figure>

Of more surprise is that Gibson’s results for 2020-22 less well
approximate the crude mortality rate than Karlinsky & Kobak, since the
crude mortality rate is the accepted method of comparing death rates
while ignoring the effects of age. While there is not enough information
in the paper to exactly replicate Gibson’s method and achieve the same
answers, part of the reason for the difference seems likely to be the
unusual step of treating population as an additive contributor to deaths
in his modification of the regression. But, compared to the differences
with methods acknowledging age, such problems are minor.

I suggest anyone interested in this topic go explore population ages and
death rates at Stats NZ themselves, and while there have a look at New
Zealand death rates by age, or indeed the public, downloadable,
standardised death rates. And then ask yourself, given the ready
availability of high quality data, is the best default course of action
to use the source that automatically compensates for the most
confounders?

[^1]: John Gibson (22 Feb 2024): Cumulative excess deaths in New Zealand
    in the COVID-19 era: biases from ignoring changes in population
    growth rates, New Zealand Economic Papers, DOI:
    10.1080/00779954.2024.2314770

[^2]: Ariel Karlinsky, Dmitry Kobak (2021) Tracking excess mortality
    across countries during the COVID-19 pandemic with the World
    Mortality Dataset eLife 10:e69336. Code available from
    https://github.com/dkobak/excess-mortality

[^3]: Price, Richard (1773). Observations on Reversionary Payments.
    United Kingdom: (n.p.).

[^4]: Report on the Statistics of New Zealand, 1890. Published by George
    Didsbury, Government Printer, Wellington., 1891.
    https://www3.stats.govt.nz/historic_publications/1890-official-handbook/1890-official-handbook.html
    Age standardised mortality is in the section “Adjusted death-rate a
    better means of comparison”.

[^5]: Actuaries Institute: CMI Working Paper 180
    https://www.actuaries.org.uk/learn-and-develop/continuous-mortality-investigation/cmi-working-papers/mortality-projections/cmi-working-paper-180

[^6]: Ashley Bloomfield, 2024, personal communication

[^7]: NZ annual deaths are available from
    <https://infoshare.stats.govt.nz> in Population : Deaths : Deaths by
    age and sex (Annual-Dec). NZ mean annual population is available
    from Population : Population Estimates - DPE : Estimated Resident
    Population by Age and Sex (1991+) (Annual-Dec) : Mean year ended.

[^8]: Australian Bureau of Statistics.
    https://www.abs.gov.au/articles/measuring-australias-excess-mortality-during-covid-19-pandemic-until-first-quarter-2023#methodology
