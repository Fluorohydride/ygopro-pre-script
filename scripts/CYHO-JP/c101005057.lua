--ブレイク・オブ・ザ・ワールド
--Break of the World
--Scripted by Eerie Code
function c101005057.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101005057,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101005057.lvtg)
	e2:SetOperation(c101005057.lvop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c101005057.condition)
	e3:SetTarget(c101005057.target)
	c:RegisterEffect(e3)
end
function c101005057.lvfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(c101005057.lvcfilter,tp,LOCATION_HAND,0,1,nil,c)
end
function c101005057.lvcfilter(c,mc)
	return c:IsType(TYPE_RITUAL) and not c:IsPublic() and not c:IsLevel(mc:GetLevel())
end
function c101005057.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101005057.lvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101005057.lvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101005057.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c101005057.lvcfilter,tp,LOCATION_HAND,0,1,1,nil,g:GetFirst())
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(cg:GetFirst())
end
function c101005057.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local pc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and pc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		pc:RegisterEffect(e1)
	end
end
function c101005057.cfilter(c,tp)
	return c:IsCode(46427957,72426662) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101005057.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101005057.cfilter,1,nil,tp)
end
function c101005057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local b2=g:GetCount()>0
	if chk==0 then return b1 or b2 end
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(101005057,0),aux.Stringid(101005057,1))
	elseif b1 then
		sel=Duel.SelectOption(tp,aux.Stringid(101005057,0))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(101005057,1))
	end
	if sel==0 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c101005057.drop)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(c101005057.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c101005057.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101005057.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
