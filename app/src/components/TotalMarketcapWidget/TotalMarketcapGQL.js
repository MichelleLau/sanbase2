import gql from 'graphql-tag'

export const totalMarketcapGQL = gql`
  query historyPrice($from: DateTime!, $slug: String) {
    historyPrice(from: $from, slug: $slug) {
      marketcap,
      volume,
      datetime
    }
  }
`