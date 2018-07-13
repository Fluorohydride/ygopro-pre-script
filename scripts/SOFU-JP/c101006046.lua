--ヴェルスパーダ・パラディオン
--Verspada Palladion
--Scripted by Eerie Code
function c101006046.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c101006046.matcheck)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101006046.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c101006046.atklimit)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101006046,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101006046.seqcon)
	e3:SetTarget(c101006046.seqtg)
	e3:SetOperation(c101006046.seqop)
	c:RegisterEffect(e3)
end
function c101006046.matcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x116)
end
function c101006046.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c101006046.atklimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c101006046.seqcfilter(c,tp,lg)
	return c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c101006046.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c101006046.seqcfilter,1,nil,tp,lg)
end
function c101006046.seqfilter(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:GetSequence()<5 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
end
function c101006046.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101006046.seqfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c101006046.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101006046,1))
	Duel.SelectTarget(tp,c101006046.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function c101006046.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ttp=tc:GetControler()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(ttp,LOCATION_MZONE,ttp,LOCATION_REASON_CONTROL)<=0 then return end
	local p1,p2
	if tc:IsControler(tp) then
		p1=LOCATION_MZONE
		p2=0
	else
		p2=LOCATION_MZONE
		p1=0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2))
end
