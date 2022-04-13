select
  str_to_date(concat(yearweek(dt.hiring_date), ' Sunday'), '%X%V %W') as date,
  wk.weekly_from_TSO as weekly_from_TSO_general
from (   
  select      
    case when hiring_date is null then year(hiring_verified) else year(hiring_date) end as year,
 		case when hiring_date is null then week(hiring_verified, 0) else week(hiring_date, 0) end as week,
 		case when hiring_date is null then date(hiring_verified) else date(hiring_date) end as hiring_date,
    sum(final.hire_value) as daily,         		
    sum(if(hiring_date is not null, final.hire_value, 0)) as daily_from_TSO,
    sum(if(hiring_verified is not null, final.hire_value, 0)) as daily_from_sherlock   
  from (     
    select        
      compensations.hiring_date,       
      compensations.hiring_verified,       
      case          
        when compensations.periodicity = 'yearly' then dollars         
        when compensations.periodicity = 'monthly' then dollars*12         
        when compensations.periodicity = 'weekly' then dollars*48
        when compensations.periodicity = 'daily' then dollars*240        
        when compensations.periodicity = 'hourly' then dollars*1920      
        when compensations.periodicity = 'project' then dollars
      end as hire_value     
    from (
      select          
        oc.periodicity,         
        osh.hiring_date,         
        osh.hiring_verified,         
        case
	        when oc.max_amount is not null then IF(oc.currency = 'COP$', oc.max_amount/4000, oc.max_amount)
	        else IF(oc.currency = 'COP$', oc.min_amount/4000, oc.min_amount)
        end as dollars
      from opportunity_stats_hires osh       
      inner join opportunities o on o.id = osh.opportunity_id       
      inner join opportunity_compensations oc on o.id = oc.opportunity_id and oc.active
      where oc.currency in ('COP$', 'USD$')       
    ) as compensations   
  ) as final group by 1,2,3 ) as dt 
left join (
  select      
    case when hiring_date is null then year(hiring_verified) else year(hiring_date) end as year, 		
    case when hiring_date is null then week(hiring_verified, 0) else week(hiring_date, 0) end as week,     
    sum(final.hire_value) as weekly,         		
    sum(if(hiring_date is not null, final.hire_value, 0)) as weekly_from_TSO,         		
    sum(if(hiring_verified is not null, final.hire_value, 0)) as weekly_from_sherlock   
  from(     
    select        
      compensations.hiring_date,       
      compensations.hiring_verified,       
      case          
        when compensations.periodicity = 'yearly' then dollars         
        when compensations.periodicity = 'monthly' then dollars*12
        when compensations.periodicity = 'weekly' then dollars*48
        when compensations.periodicity = 'daily' then dollars*240
        when compensations.periodicity = 'hourly' then dollars*1920
        when compensations.periodicity = 'project' then dollars
      end as hire_value     
    from (
      select          
        oc.periodicity,         
        osh.hiring_date,         
        osh.hiring_verified,         
        case
	        when oc.max_amount is not null then IF(oc.currency = 'COP$', oc.max_amount/4000, oc.max_amount)
	        else IF(oc.currency = 'COP$', oc.min_amount/4000, oc.min_amount)
        end as dollars
      from opportunity_stats_hires osh       
      inner join opportunities o on o.id = osh.opportunity_id       
      inner join opportunity_compensations oc on o.id = oc.opportunity_id and oc.active
      where oc.currency in ('COP$', 'USD$')       
    ) as compensations   
  ) as final group by 1,2 
) as wk  on wk.year = dt.year and wk.week = dt.week
group by 1