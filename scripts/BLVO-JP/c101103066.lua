--ツッパリーチ
--
--Script by Real_Scl
function c101103066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--redraw (rule)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103066,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c101103066.drcon)
	e2:SetCost(c101103066.drcost)
	e2:SetTarget(c101103066.drtg)
	e2:SetOperation(c101103066.drop)
	c:RegisterEffect(e2)
	--redraw (effect)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101103066,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DRAW)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c101103066.drcon2)
	e3:SetCost(c101103066.drcost)
	e3:SetTarget(c101103066.drtg2)
	e3:SetOperation(c101103066.drop2)
	c:RegisterEffect(e3)
end
function c101103066.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE
end
function c101103066.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101103066.tdfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function c101103066.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c101103066.tdfilter,1,nil)
	if chk==0 then return e:GetLabel()==100 and #tg>0 and Duel.IsPlayerCanDraw(tp,1) end
	e:SetLabel(0)
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		tc=tg:Select(tp,1,1,nil)
	end
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101103066.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c101103066.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_EFFECT
end
function c101103066.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=eg:Filter(c101103066.tdfilter,1,nil)
	if chk==0 then return e:GetLabel()==100 and c:IsAbleToGrave() and #tg>0 and Duel.IsPlayerCanDraw(tp,1) end
	e:SetLabel(0)
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		tc=tg:Select(tp,1,1,nil)
	end
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101103066.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)<=0 or not c:IsLocation(LOCATION_GRAVE) then return end
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end