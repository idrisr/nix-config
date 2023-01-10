self: super: {
  awscost = self.writeShellApplication {
    name = "awscost";

    runtimeInputs = with self; [ awscli jq ];
    text = ''
      set -e
      set -u

      #inclusive
      start="$(date -u -I --date='1 days ago')"

      #exclusive
      end="$(date -u -I)"

      cost=$(aws ce get-cost-and-usage \
          --time-period Start="$start",End="$end" \
          --granularity DAILY \
          --output json \
          --metrics "BlendedCost" \
          --group-by Type=DIMENSION,Key=SERVICE Type=TAG,Key=Environment |
          jq '[.ResultsByTime[].Groups[].Metrics.BlendedCost.Amount|tonumber] | add')

      printf "$start UTC: \$%0.2f\n" "$cost"
    '';
  };
}
