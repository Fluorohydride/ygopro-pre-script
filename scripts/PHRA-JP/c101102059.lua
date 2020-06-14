--双天の調伏
--
--Script by JustFish
function c101102059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101102074+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101102059.target)
	e1:SetOperation(c101102059.activate)
	c:RegisterEffect(e1)
end
function c101102059.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x24d)
end
function c101102059.ffilter(c,tp)
	return c:IsPreviousSetCard(0x24d) and c:GetPreviousControler()==tp and c:GetPreviousTypeOnField()&TYPE_FUSION~=0
		and c:IsPreviousPosition(POS_FACEUP)
end
function c101102059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101102059.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c101102059.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function c101102059.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(c101102059.ffilter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(101102059,2)) then
			local b1=Duel.IsPlayerCanDraw(tp,1)
			local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
			local sel=0
			if b1 and b2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
				sel=Duel.SelectOption(tp,aux.Stringid(101102059,0),aux.Stringid(101102059,1))+1
			elseif b1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
				sel=Duel.SelectOption(tp,aux.Stringid(101102059,0))+1
			elseif b2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
				sel=Duel.SelectOption(tp,aux.Stringid(101102059,1))+2
			end
			if sel==1 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			elseif sel==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,1,1,nil)
				if #g>0 then
					Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
				end
			end
		end
	end
end
