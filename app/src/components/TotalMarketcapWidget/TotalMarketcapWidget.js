import React from 'react'
import moment from 'moment'
import { graphql } from 'react-apollo'
import { Bar, Line } from 'react-chartjs-2'
import { totalMarketcapGQL } from './TotalMarketcapGQL'
import { formatNumber } from '../../utils/formatting'
import './TotalMarketcapWidget.css'

/*
  marketcap = int;
  datetime: string
*/

const charOptions = {
  responsive: true,
  showTooltips: true,
  pointDot: false,
  scaleShowLabels: false,
  pointHitDetectionRadius: 1,
  datasetFill: false,
  scaleFontSize: 0,
  animation: false,
  pointRadius: 0,
  legend: {
    display: false
  },
  elements: {
    point: {
      hitRadius: 1,
      hoverRadius: 1,
      radius: 0
    }
  },
  hover: {
    mode: 'point',
    intersect: false
  },
  tooltips: {
    mode: 'x',
    intersect: false,
    titleMarginBottom: 16,
    titleFontSize: 14,
    titleFontColor: '#3d4450',
    backgroundColor: 'rgba(255, 255, 255, 0.8)',
    cornerRadius: 3,
    borderColor: 'rgba(38, 43, 51, 0.7)',
    borderWidth: 1,
    bodyFontSize: 14,
    bodySpacing: 8,
    bodyFontColor: '#3d4450',
    displayColors: true,
    callbacks: {
      title: item => {
        return moment(item[0].xLabel).format('dddd, MMM DD YYYY, HH:mm:ss UTC')
      },
      label: (tooltipItem, data) => {
        console.log(data, tooltipItem)
        // formatNumber(data.datasets[tooltipItem.datasetIndex], {
        // currency: 'USD'
        // }
        // )
      }
    }
  },
  scales: {
    yAxes: [
      {
        ticks: {
          display: false
        }
      }
    ],
    xAxes: [
      {
        ticks: {
          display: false
        }
      }
    ]
  }
}

const options = {
  type: 'line',
  borderColor: 'rgba(45, 94, 57, 1)',
  // borderJoinStyle: 'round',
  // borderCapStyle: 'square',
  borderWidth: 1,
  lineTension: 0.1,
  pointBorderWidth: 1,
  backgroundColor: 'rgba(214, 235, 219, .8)'
}

const TotalMarketcapWidget = ({ data: { historyPrice = false } }) => {
  console.log(historyPrice)

  const marketcapDataset = {
    labels: historyPrice && historyPrice.map(data => data.datetime),
    datasets: [
      {
        data: historyPrice && historyPrice.map(data => data.marketcap),
        label: 'Marketcap',
        ...options
      }
    ]
  }

  return (
    <div className='TotalMarketcapWidget'>
      <h3 className='TotalMarketcapWidget__label'>Total marketcap</h3>
      <h4 className='TotalMarketcapWidget__value'>
        {formatNumber(
          historyPrice && historyPrice[historyPrice.length - 1].marketcap,
          {
            currency: 'USD'
          }
        )}
      </h4>
      {historyPrice && <Bar data={marketcapDataset} options={charOptions} />}
    </div>
  )
}

const ApolloTotalMarketcapWidget = graphql(totalMarketcapGQL)(
  TotalMarketcapWidget
)

ApolloTotalMarketcapWidget.defaultProps = {
  from: moment().subtract(3, 'months').utc().format(),
  slug: 'TOTAL_MARKET'
}

export default ApolloTotalMarketcapWidget
