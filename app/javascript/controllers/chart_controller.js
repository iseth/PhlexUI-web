import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'

// Function to get theme color
const getThemeColor = (name) => {
  const color = getComputedStyle(document.documentElement).getPropertyValue(`--${name}`)
  const [ hue, saturation, lightness ] = color.split(' ')
  return `hsl(${hue}, ${saturation}, ${lightness})`
}

const defaultThemeColor = () => {
  return {
    backgroundColor: getThemeColor('background'),
    hoverBackgroundColor: getThemeColor('accent'),
    borderColor: getThemeColor('primary'),
    borderWidth: 1,
  }
}

// Chart controller
export default class extends Controller {
  static values = {
    options: {
      type: Object,
      default: {},
    }
  }

  // Function to initialize the chart when the controller is connected
  connect() {
    this.initDarkModeObserver()
    this.initChart()
  }

  disconnect() {
    this.darkModeObserver?.disconnect()
    this.chart?.destroy()
  }

  // Function to initialize the chart
  initChart() {
    this.setColors()
    const ctx = this.element.getContext('2d');
    this.chart = new Chart(ctx, this.mergeOptionsWithDefaults());
  }

  setColors() {
    this.setDefaultColorsForChart()
  }

  // Function to set chart default colors
  setDefaultColorsForChart() {
    Chart.defaults.color = getThemeColor('muted-foreground') // font color
    Chart.defaults.borderColor = getThemeColor('border') // border color
    Chart.defaults.backgroundColor = getThemeColor('background') // background color

    // tooltip colors
    Chart.defaults.plugins.tooltip.backgroundColor = getThemeColor('background')
    Chart.defaults.plugins.tooltip.borderColor = getThemeColor('border')
    Chart.defaults.plugins.tooltip.titleColor = getThemeColor('foreground')
    Chart.defaults.plugins.tooltip.bodyColor = getThemeColor('muted-foreground')
    Chart.defaults.plugins.tooltip.borderWidth = 1

    // legend
    // options.plugins.legend.labels
    Chart.defaults.plugins.legend.labels.boxWidth = 12
    Chart.defaults.plugins.legend.labels.boxHeight = 12
    Chart.defaults.plugins.legend.labels.borderWidth = 0
    Chart.defaults.plugins.legend.labels.useBorderRadius = true
    Chart.defaults.plugins.legend.labels.borderRadius = getThemeColor('radius')
  }

  // Function to refresh the chart
  refreshChart() {
    // Destroy the chart if it's a valid Chart.js instance
    this.chart?.destroy()
    // Reinitialize the chart
    this.initChart()
  }

  // Function to initialize the dark mode observer
  initDarkModeObserver() {
    this.darkModeObserver = new MutationObserver(() => {
      this.refreshChart()
    })
    this.darkModeObserver.observe(document.documentElement, { attributeFilter: ['class'] })
  }

  // Function to merge the options with the defaults
  mergeOptionsWithDefaults() {
    return {
      ...this.optionsValue,
      data: {
        ...this.optionsValue.data,
        datasets: this.optionsValue.data.datasets.map((dataset) => {
          return {
            ...defaultThemeColor(),
            ...dataset,
          }
        })
      }
    }
  }
}