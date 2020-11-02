--おジャマ・ピンク
--Ojama Pink
--Ejeffers1239
function c101103036.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103036,1))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,101103036)
	e1:SetCondition(c101103036.thcon)
	e1:SetTarget(c101103036.target)
	e1:SetOperation(c101103036.activate)
	c:RegisterEffect(e1)
end
function c101103036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c101103036.target(e,tp,eg,ep,ev,re,r,rp,chk)
<<<<<<< HEAD
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
=======
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
>>>>>>> upstream/master
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c101103036.activate(e,tp,eg,ep,ev,re,r,rp)
<<<<<<< HEAD
    local h1=Duel.Draw(tp,1,REASON_EFFECT)
    local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
    if h1>0 or h2>0 then Duel.BreakEffect() end
    local groundcollapse=false
    if h1>0 then
        Duel.ShuffleHand(tp)
        Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		local dc=Duel.GetOperatedGroup():GetFirst()
		if dc:IsSetCard(0xf) then groundcollapse=true end
    end
    if h2>0 then 
        Duel.ShuffleHand(1-tp)
        Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
    end
=======
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	local groundcollapse=false
	if h1>0 then
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		local dc=Duel.GetOperatedGroup():GetFirst()
		if dc:IsSetCard(0xf) then groundcollapse=true end
	end
	if h2>0 then
		Duel.ShuffleHand(1-tp)
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
>>>>>>> upstream/master
	if groundcollapse and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(101103036,0)) then
		Duel.BreakEffect()
		local zone=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
		if tp==1 then
			zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(zone)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
