import React from 'react'
import moment from 'moment'
import { graphql } from 'react-apollo'
import { Line } from 'react-chartjs-2'
import { totalMarketcapGQL } from './TotalMarketcapGQL'
import { formatNumber } from '../../utils/formatting'
import './TotalMarketcapWidget.css'

const charOptions = {
  animation: false,
  maintainAspectRatio: true,
  responsive: true,
  pointRadius: 0,
  layout: {
    padding: {
      left: -10
    }
  },
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
      label: tooltipItem =>
        formatNumber(tooltipItem.yLabel, {
          currency: 'USD'
        })
    }
  },
  scales: {
    yAxes: [
      {
        ticks: {
          display: false
        },
        gridLines: {
          display: false
        }
      }
    ],
    xAxes: [
      {
        ticks: {
          display: false
        },
        gridLines: {
          display: false
        }
      }
    ]
  }
}

const options = {
  borderColor: 'rgba(45, 94, 57, 1)',
  borderWidth: 1,
  lineTension: 0.1,
  pointBorderWidth: 1,
  backgroundColor: 'rgba(214, 235, 219, .8)'
}

const calculate24HourVolumeAmplitude = historyPrice => {
  if (!historyPrice) return 'No data'

  const oneDayAgo = moment().subtract(1, 'days')
  const historyPriceLastItemIndex = historyPrice.length - 1

  if (
    moment(historyPrice[historyPriceLastItemIndex].datetime).isBefore(oneDayAgo)
  ) {
    return 'Data is too old'
  }

  for (let i = historyPriceLastItemIndex - 1; i >= 0; i--) {
    if (moment(historyPrice[i].datetime).isBefore(oneDayAgo)) {
      return (
        historyPrice[historyPriceLastItemIndex + 1].volume -
        historyPrice[historyPriceLastItemIndex].volume
      )
    }
  }
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

  const volumeAmplitude = calculate24HourVolumeAmplitude(historyPrice)

  const volumePrice =
    typeof volumeAmplitude === 'string'
      ? volumeAmplitude
      : formatNumber(volumeAmplitude, {
        currency: 'USD'
      })

  const totalmarketCapPrice = formatNumber(
    historyPrice && historyPrice[historyPrice.length - 1].marketcap,
    {
      currency: 'USD'
    }
  )

  return (
    <div className='TotalMarketcapWidget'>
      <div className='TotalMarketcapWidget__info'>
        <div className='TotalMarketcapWidget__left'>
          <h3 className='TotalMarketcapWidget__label'>Total marketcap</h3>
          <h4 className='TotalMarketcapWidget__value'>{totalmarketCapPrice}</h4>
        </div>
        <div className='TotalMarketcapWidget__right'>
          <h3 className='TotalMarketcapWidget__label'>Vol 24 hr</h3>
          <h4 className='TotalMarketcapWidget__value'>{volumePrice}</h4>
        </div>
      </div>
      {historyPrice && (
        <Line
          data={marketcapDataset}
          options={charOptions}
          className='TotalMarketcapWidget__chart'
        />
      )}
    </div>
  )
}

const ApolloTotalMarketcapWidget = graphql(totalMarketcapGQL)(
  TotalMarketcapWidget
)

ApolloTotalMarketcapWidget.defaultProps = {
  from: moment()
    .subtract(3, 'months')
    .utc()
    .format(),
  slug: 'TOTAL_MARKET'
}

export default ApolloTotalMarketcapWidget
