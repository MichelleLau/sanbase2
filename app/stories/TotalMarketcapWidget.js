import React from 'react'
import { storiesOf } from '@storybook/react'
import TotalMarketcapWidget from './../src/components/TotalMarketcapWidget/TotalMarketcapWidget'

storiesOf('TotalMarketcapWidget', module)
  .add('Projects overview help content', () => (
    <div style={{ padding: 20 }}>
      <TotalMarketcapWidget from='2018-04-01T12:33:17Z' />
    </div>
  ))
