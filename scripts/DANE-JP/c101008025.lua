79

end

80

--

81

function c101008025.con2(e,tp,eg,ep,ev,re,r,rp)

82

  local ph=Duel.GetCurrentPhase()

83

  return eg:IsExists(c101008025.cfilter1,1,nil,1-tp)

84

    and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))

85

    and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)

86

end

87

function c101008025.op2(e,tp,eg,ep,ev,re,r,rp)

88

  local lg=eg:Filter(c101008025.cfilter1,nil,1-tp)

89

  lg:KeepAlive()

90

  e:SetLabelObject(lg)

91

  Duel.RegisterFlagEffect(tp,101008125,RESET_CHAIN,0,1)

92

end

93

--

94

function c101008025.con3(e,tp,eg,ep,ev,re,r,rp)

95

  return Duel.GetFlagEffect(tp,101008125)>0

96

end

97

function c101008025.op3(e,tp,eg,ep,ev,re,r,rp)

98

  Duel.ResetFlagEffect(tp,101008125)

99

  local lg=e:GetLabelObject():GetLabelObject()

100

  local rnum=lg:GetSum(Card.GetAttack)

101

  if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end

102

  Duel.RegisterFlagEffect(tp,101008025,RESET_PHASE+PHASE_END,0,1)

103

end

104

--

105

function c101008025.con4(e,tp,eg,ep,ev,re,r,rp)

106

  return Duel.GetFlagEffect(tp,101008025)<1

107

end

108

function c101008025.op4(e,tp,eg,ep,ev,re,r,rp)

109

  return Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))

110

end

111

--

112

​
function c101008025.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101008025,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101008025)
	e1:SetCost(c101008025.cost)
	e1:SetOperation(c101008025.operation)
	c:RegisterEffect(e1)
--
end
--
function c101008025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
--
function c101008025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101008025.con1)
	e1:SetOperation(c101008025.op1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101008025.con2)
	e2:SetOperation(c101008025.op2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c101008025.con3)
	e3:SetOperation(c101008025.op3)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c101008025.con4)
	e4:SetOperation(c101008025.op4)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
--
end
--
function c101008025.cfilter1(c,sp)
	return c:IsType(TYPE_EFFECT)
		and c:GetSummonPlayer()==sp and c:IsFaceup()
end
function c101008025.con1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c101008025.cfilter1,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2
			or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c101008025.op1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c101008025.cfilter1,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,101008025,RESET_PHASE+PHASE_END,0,1)
end
--
function c101008025.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c101008025.cfilter1,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c101008025.op2(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c101008025.cfilter1,nil,1-tp)
	lg:KeepAlive()
	e:SetLabelObject(lg)
	Duel.RegisterFlagEffect(tp,101008125,RESET_CHAIN,0,1)
end
--
function c101008025.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101008125)>0
end
function c101008025.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,101008125)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,101008025,RESET_PHASE+PHASE_END,0,1)
end
--
function c101008025.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101008025)<1
end
function c101008025.op4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
end
--
